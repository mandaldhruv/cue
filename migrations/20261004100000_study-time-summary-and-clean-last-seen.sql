-- Create get_cue_study_time_summary() and ensure get_cue_members() accurately reflects confirmed activity

-- 1. Function to retrieve aggregated study time metrics across all students/users for today, this week, this month, and all time
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
  FROM public.user_study_sessions s;
END;
$$;

REVOKE ALL ON FUNCTION public.get_cue_study_time_summary() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cue_study_time_summary() TO authenticated, anon, project_admin;

-- 2. Update get_cue_members() so last_seen strictly reflects confirmed activity (session activity or greeting event), not registration date
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
    COALESCE(ss.last_session_activity, gs.last_greeting_at) AS last_seen,
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
