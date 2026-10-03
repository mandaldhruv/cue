-- Add Dhruv Mandal (mndaldhruv14@gmail.com) as an authorized administrator / owner

-- 1. Insert or activate admin_members record
INSERT INTO public.admin_members (email, user_id, display_name, role, is_active)
VALUES (
  'mndaldhruv14@gmail.com',
  '489a636d-8fc8-47d5-9b9c-3c49a97cf93e',
  'Dhruv Mandal',
  'owner',
  true
)
ON CONFLICT (email) DO UPDATE
SET
  user_id = EXCLUDED.user_id,
  display_name = EXCLUDED.display_name,
  role = 'owner',
  is_active = true,
  updated_at = now();

-- 2. Update is_cue_admin to strictly authorize mndaldhruv14@gmail.com
CREATE OR REPLACE FUNCTION public.is_cue_admin()
RETURNS boolean
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_uid uuid;
  v_email text;
BEGIN
  v_uid := auth.uid();
  IF v_uid IS NULL THEN
    RETURN false;
  END IF;

  -- Look up authoritative email from auth.users for current authenticated uid
  SELECT lower(email) INTO v_email
  FROM auth.users
  WHERE id = v_uid;

  IF v_email IS NULL OR v_email = '' THEN
    v_email := lower(coalesce(auth.jwt() ->> 'email', ''));
  END IF;

  -- Strictly verify against the authorized admin emails
  IF v_email NOT IN ('hersita04@gmail.com', 'harshita301doc@gmail.com', 'mndaldhruv14@gmail.com') THEN
    RETURN false;
  END IF;

  -- Verify active record in admin_members matching email and uid
  RETURN EXISTS (
    SELECT 1
    FROM public.admin_members AS member
    WHERE member.is_active = true
      AND lower(member.email) = v_email
      AND (member.user_id IS NULL OR member.user_id = v_uid)
  );
END;
$$;

REVOKE ALL ON FUNCTION public.is_cue_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_cue_admin() TO authenticated, anon, project_admin;

-- 3. Update get_cue_members to display role as 'Admin (owner)'
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
      WHEN lower(u.email) IN ('hersita04@gmail.com', 'harshita301doc@gmail.com', 'mndaldhruv14@gmail.com') THEN 'Admin (owner)'
      WHEN am.role IS NOT NULL THEN 'Admin (' || am.role || ')'
      ELSE 'Student'
    END AS role,
    COALESCE(u.email_verified, false) AS email_verified,
    u.created_at,
    u.updated_at,
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

REVOKE ALL ON FUNCTION public.get_cue_members() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cue_members() TO authenticated, anon, project_admin;
