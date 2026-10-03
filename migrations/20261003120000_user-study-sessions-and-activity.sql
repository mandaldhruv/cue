-- Create user study sessions table for accurate activity & usage tracking
CREATE TABLE IF NOT EXISTS public.user_study_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  session_token text NOT NULL,
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  last_heartbeat_at timestamp with time zone NOT NULL DEFAULT now(),
  ended_at timestamp with time zone NOT NULL DEFAULT now(),
  duration_seconds integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  page_path text DEFAULT '/',
  resource_type text,
  resource_id text,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now()
);

-- Indexes for performance on lookups, analytics, and admin stats
CREATE INDEX IF NOT EXISTS idx_user_study_sessions_user_id ON public.user_study_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_study_sessions_token ON public.user_study_sessions(session_token);
CREATE INDEX IF NOT EXISTS idx_user_study_sessions_user_token ON public.user_study_sessions(user_id, session_token);
CREATE INDEX IF NOT EXISTS idx_user_study_sessions_last_heartbeat ON public.user_study_sessions(last_heartbeat_at);
CREATE INDEX IF NOT EXISTS idx_user_study_sessions_user_last_heartbeat ON public.user_study_sessions(user_id, last_heartbeat_at DESC);

-- Enable RLS
ALTER TABLE public.user_study_sessions ENABLE ROW LEVEL SECURITY;

-- Drop previous policies if they exist
DROP POLICY IF EXISTS "Users can insert own study sessions" ON public.user_study_sessions;
DROP POLICY IF EXISTS "Users can update own study sessions" ON public.user_study_sessions;
DROP POLICY IF EXISTS "Users can view own study sessions" ON public.user_study_sessions;
DROP POLICY IF EXISTS "Admins can view all study sessions" ON public.user_study_sessions;

-- RLS policies
CREATE POLICY "Users can insert own study sessions"
  ON public.user_study_sessions
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own study sessions"
  ON public.user_study_sessions
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own study sessions"
  ON public.user_study_sessions
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all study sessions"
  ON public.user_study_sessions
  FOR SELECT
  TO authenticated
  USING (public.is_cue_admin());

-- Atomic heartbeat recorder
CREATE OR REPLACE FUNCTION public.record_cue_study_heartbeat(
  p_session_token text,
  p_delta_seconds integer,
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
BEGIN
  v_uid := auth.uid();
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Authentication required to record study heartbeat';
  END IF;

  IF p_session_token IS NULL OR trim(p_session_token) = '' THEN
    RAISE EXCEPTION 'session_token is required';
  END IF;

  -- Clamp delta seconds to reasonable bounds (0 to 120s per heartbeat)
  v_valid_delta := GREATEST(0, LEAST(COALESCE(p_delta_seconds, 0), 120));

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
        page_path = COALESCE(NULLIF(trim(p_page_path), ''), page_path),
        resource_type = COALESCE(p_resource_type, resource_type),
        resource_id = COALESCE(p_resource_id, resource_id),
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

  -- Create fresh session row
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

-- Function for admins to retrieve recent sessions of a specific member
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
  ORDER BY s.started_at DESC
  LIMIT LEAST(p_limit, 50);
END;
$$;

-- Drop and recreate get_cue_members to accurately return study time and true last active timestamp
DROP FUNCTION IF EXISTS public.get_cue_members();

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
      MAX(s.last_heartbeat_at) AS last_session_activity
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
      WHEN lower(u.email) IN ('hersita04@gmail.com', 'harshita301doc@gmail.com') THEN 'Admin (owner)'
      WHEN am.role IS NOT NULL THEN 'Admin (' || am.role || ')'
      ELSE 'Student'
    END AS role,
    COALESCE(u.email_verified, false) AS email_verified,
    u.created_at,
    u.updated_at,
    -- Last Active: accurate latest confirmed user activity from study sessions or greeting events
    COALESCE(ss.last_session_activity, gs.last_greeting_at, u.updated_at, u.created_at) AS last_seen,
    COALESCE(ss.total_study_seconds, 0)::bigint AS total_study_seconds,
    COALESCE(ss.session_count, 0)::bigint AS session_count
  FROM auth.users u
  LEFT JOIN public.admin_members am ON lower(am.email) = lower(u.email) AND am.is_active = true
  LEFT JOIN session_stats ss ON ss.user_id = u.id
  LEFT JOIN greeting_stats gs ON gs.user_id = u.id
  ORDER BY u.created_at DESC;
END;
$$;

-- Grant permissions
REVOKE ALL ON FUNCTION public.record_cue_study_heartbeat(text, integer, text, boolean, text, text, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.record_cue_study_heartbeat(text, integer, text, boolean, text, text, jsonb) TO authenticated;

REVOKE ALL ON FUNCTION public.get_cue_member_sessions(uuid, integer) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cue_member_sessions(uuid, integer) TO authenticated, project_admin;

REVOKE ALL ON FUNCTION public.get_cue_members() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cue_members() TO authenticated, anon, project_admin;
