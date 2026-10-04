-- Exclude Admin Panel activity from Study Time tracking
-- Administrative activity is NOT study activity. Study Time must represent ONLY time spent using the student-facing website.

-- 1. Zero out any historical duration recorded on admin routes in user_study_sessions
UPDATE public.user_study_sessions
SET duration_seconds = 0
WHERE page_path IS NOT NULL AND (
  lower(trim(page_path)) = '/admin'
  OR lower(trim(page_path)) LIKE '/admin/%'
  OR lower(trim(page_path)) LIKE '/admin?%'
);

-- 2. Update record_cue_study_heartbeat to strictly reject or zero study delta from Admin routes
CREATE OR REPLACE FUNCTION public.record_cue_study_heartbeat(
  p_session_token text,
  p_delta_seconds integer DEFAULT 0,
  p_page_path text DEFAULT '/',
  p_is_closing boolean DEFAULT false,
  p_resource_type text DEFAULT NULL,
  p_resource_id text DEFAULT NULL,
  p_metadata jsonb DEFAULT '{}'::jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_uid uuid;
  v_session_id uuid;
  v_existing_active boolean;
  v_last_heartbeat timestamptz;
  v_valid_delta integer;
  v_now timestamptz := now();
  v_is_admin_path boolean := false;
BEGIN
  v_uid := auth.uid();
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Authentication required to record study heartbeat';
  END IF;

  IF p_session_token IS NULL OR trim(p_session_token) = '' THEN
    RAISE EXCEPTION 'session_token is required';
  END IF;

  -- Check if path is in Admin Panel
  IF p_page_path IS NOT NULL AND (
    lower(trim(p_page_path)) = '/admin'
    OR lower(trim(p_page_path)) LIKE '/admin/%'
    OR lower(trim(p_page_path)) LIKE '/admin?%'
  ) THEN
    v_is_admin_path := true;
  END IF;

  -- Administrative activity inside the Admin Panel must NEVER contribute to Study Time
  IF v_is_admin_path THEN
    v_valid_delta := 0;
  ELSE
    -- Clamp delta seconds to reasonable bounds (0 to 120s per heartbeat)
    v_valid_delta := GREATEST(0, LEAST(COALESCE(p_delta_seconds, 0), 120));
  END IF;

  -- Look for an existing session row for this user & token
  SELECT id, is_active, last_heartbeat_at
  INTO v_session_id, v_existing_active, v_last_heartbeat
  FROM public.user_study_sessions
  WHERE user_id = v_uid AND session_token = p_session_token
  ORDER BY started_at DESC
  LIMIT 1;

  IF v_session_id IS NOT NULL THEN
    -- If the session was active within the last 15 minutes, continue accumulating
    IF v_last_heartbeat > (v_now - interval '15 minutes') THEN
      UPDATE public.user_study_sessions
      SET
        last_heartbeat_at = v_now,
        ended_at = v_now,
        duration_seconds = duration_seconds + v_valid_delta,
        is_active = CASE WHEN p_is_closing THEN false ELSE true END,
        page_path = CASE
          WHEN v_is_admin_path THEN page_path
          ELSE COALESCE(NULLIF(trim(p_page_path), ''), page_path)
        END,
        resource_type = CASE
          WHEN v_is_admin_path THEN resource_type
          ELSE COALESCE(p_resource_type, resource_type)
        END,
        resource_id = CASE
          WHEN v_is_admin_path THEN resource_id
          ELSE COALESCE(p_resource_id, resource_id)
        END,
        metadata = CASE
          WHEN p_metadata IS NOT NULL AND p_metadata != '{}'::jsonb
          THEN metadata || p_metadata
          ELSE metadata
        END,
        updated_at = v_now
      WHERE id = v_session_id;

      RETURN jsonb_build_object(
        'status', 'updated',
        'session_id', v_session_id,
        'delta_added', v_valid_delta
      );
    ELSE
      -- Mark previous session as completed before creating a new one
      UPDATE public.user_study_sessions
      SET is_active = false, updated_at = v_now
      WHERE id = v_session_id;
    END IF;
  END IF;

  -- If this is an admin path and no active study session exists, do NOT create a study session row
  IF v_is_admin_path THEN
    RETURN jsonb_build_object(
      'status', 'ignored',
      'reason', 'admin_activity_excluded',
      'delta_added', 0
    );
  END IF;

  -- Create fresh session row for student-facing study activity
  INSERT INTO public.user_study_sessions (
    user_id,
    session_token,
    started_at,
    last_heartbeat_at,
    ended_at,
    duration_seconds,
    is_active,
    page_path,
    resource_type,
    resource_id,
    metadata,
    created_at,
    updated_at
  ) VALUES (
    v_uid,
    p_session_token,
    v_now - (v_valid_delta || ' seconds')::interval,
    v_now,
    v_now,
    v_valid_delta,
    NOT p_is_closing,
    COALESCE(NULLIF(trim(p_page_path), ''), '/'),
    p_resource_type,
    p_resource_id,
    COALESCE(p_metadata, '{}'::jsonb),
    v_now,
    v_now
  )
  RETURNING id INTO v_session_id;

  RETURN jsonb_build_object(
    'status', 'created',
    'session_id', v_session_id,
    'delta_added', v_valid_delta
  );
END;
$$;

-- 3. Update get_cue_study_time_summary() so Today, This Week, This Month, and All Time only aggregate student-facing study activity
CREATE OR REPLACE FUNCTION public.get_cue_study_time_summary()
RETURNS TABLE (
  today_seconds bigint,
  week_seconds bigint,
  month_seconds bigint,
  all_time_seconds bigint
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  RETURN QUERY
  SELECT
    COALESCE(SUM(CASE WHEN s.last_heartbeat_at >= (date_trunc('day', now() AT TIME ZONE 'Asia/Kolkata') AT TIME ZONE 'Asia/Kolkata') THEN s.duration_seconds ELSE 0 END), 0)::bigint AS today_seconds,
    COALESCE(SUM(CASE WHEN s.last_heartbeat_at >= (date_trunc('week', now() AT TIME ZONE 'Asia/Kolkata') AT TIME ZONE 'Asia/Kolkata') THEN s.duration_seconds ELSE 0 END), 0)::bigint AS week_seconds,
    COALESCE(SUM(CASE WHEN s.last_heartbeat_at >= (date_trunc('month', now() AT TIME ZONE 'Asia/Kolkata') AT TIME ZONE 'Asia/Kolkata') THEN s.duration_seconds ELSE 0 END), 0)::bigint AS month_seconds,
    COALESCE(SUM(s.duration_seconds), 0)::bigint AS all_time_seconds
  FROM public.user_study_sessions s
  WHERE s.page_path IS NULL OR (
    lower(trim(s.page_path)) <> '/admin'
    AND lower(trim(s.page_path)) NOT LIKE '/admin/%'
    AND lower(trim(s.page_path)) NOT LIKE '/admin?%'
  );
END;
$$;

-- 4. Update get_cue_members() so total_study_seconds and session_count strictly reflect student-facing study activity
CREATE OR REPLACE FUNCTION public.get_cue_members()
RETURNS TABLE (
  id uuid,
  email text,
  name text,
  role text,
  email_verified boolean,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  last_seen timestamp with time zone,
  total_study_seconds bigint,
  session_count bigint
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  RETURN QUERY
  WITH session_stats AS (
    SELECT
      s.user_id,
      COALESCE(SUM(s.duration_seconds), 0)::bigint AS total_study_seconds,
      COUNT(s.id)::bigint AS session_count,
      MAX(s.last_heartbeat_at) AS last_study_activity
    FROM public.user_study_sessions s
    WHERE s.page_path IS NULL OR (
      lower(trim(s.page_path)) <> '/admin'
      AND lower(trim(s.page_path)) NOT LIKE '/admin/%'
      AND lower(trim(s.page_path)) NOT LIKE '/admin?%'
    )
    GROUP BY s.user_id
  ),
  all_user_activity AS (
    SELECT
      s.user_id,
      MAX(s.last_heartbeat_at) AS last_any_activity
    FROM public.user_study_sessions s
    GROUP BY s.user_id
  ),
  greeting_stats AS (
    SELECT
      gde.user_id,
      MAX(gde.created_at) AS last_greeting_at
    FROM public.greeting_display_events gde
    GROUP BY gde.user_id
  )
  SELECT 
    u.id,
    COALESCE(u.email, '') AS email,
    COALESCE(NULLIF(trim(u.profile->>'name'), ''), split_part(COALESCE(u.email, 'member@cue.study'), '@', 1)) AS name,
    CASE 
      WHEN lower(u.email) IN (
        'hersita04@gmail.com',
        'harshita301doc@gmail.com',
        'harsyng14@gmail.com'
      ) THEN 'Admin (owner)'
      WHEN am.role IS NOT NULL THEN 'Admin (' || am.role || ')'
      ELSE 'Student'
    END AS role,
    COALESCE(u.email_verified, false) AS email_verified,
    u.created_at,
    u.updated_at,
    COALESCE(ss.last_study_activity, aua.last_any_activity, gs.last_greeting_at) AS last_seen,
    COALESCE(ss.total_study_seconds, 0)::bigint AS total_study_seconds,
    COALESCE(ss.session_count, 0)::bigint AS session_count
  FROM auth.users u
  LEFT JOIN public.admin_members am ON lower(am.email) = lower(u.email) AND am.is_active = true
  LEFT JOIN session_stats ss ON ss.user_id = u.id
  LEFT JOIN all_user_activity aua ON aua.user_id = u.id
  LEFT JOIN greeting_stats gs ON gs.user_id = u.id
  ORDER BY u.created_at DESC;
END;
$$;

-- 5. Update get_cue_member_sessions() so recent sessions modal shows genuine student study visits
CREATE OR REPLACE FUNCTION public.get_cue_member_sessions(
  p_user_id uuid,
  p_limit integer DEFAULT 15
)
RETURNS TABLE (
  id uuid,
  started_at timestamp with time zone,
  last_heartbeat_at timestamp with time zone,
  ended_at timestamp with time zone,
  duration_seconds integer,
  is_active boolean,
  page_path text,
  resource_type text,
  resource_id text
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  RETURN QUERY
  SELECT
    s.id,
    s.started_at,
    s.last_heartbeat_at,
    s.ended_at,
    s.duration_seconds,
    s.is_active,
    s.page_path,
    s.resource_type,
    s.resource_id
  FROM public.user_study_sessions s
  WHERE s.user_id = p_user_id
    AND (
      s.page_path IS NULL OR (
        lower(trim(s.page_path)) <> '/admin'
        AND lower(trim(s.page_path)) NOT LIKE '/admin/%'
        AND lower(trim(s.page_path)) NOT LIKE '/admin?%'
      )
    )
  ORDER BY s.started_at DESC
  LIMIT p_limit;
END;
$$;
