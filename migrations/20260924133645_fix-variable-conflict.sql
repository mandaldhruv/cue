CREATE OR REPLACE FUNCTION public.get_cue_members()
RETURNS TABLE (
  id uuid,
  email text,
  name text,
  role text,
  email_verified boolean,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  last_seen timestamp with time zone
)
LANGUAGE sql
STABLE SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
  SELECT 
    u.id,
    COALESCE(u.email, '') AS email,
    COALESCE(NULLIF(trim(u.profile->>'name'), ''), split_part(COALESCE(u.email, 'member@cue.study'), '@', 1)) AS name,
    CASE 
      WHEN lower(u.email) = 'hersita04@gmail.com' THEN 'Admin (owner)'
      WHEN am.role IS NOT NULL THEN 'Admin (' || am.role || ')'
      WHEN u.is_project_admin = true THEN 'Admin'
      ELSE 'Student'
    END AS role,
    COALESCE(u.email_verified, false) AS email_verified,
    u.created_at,
    u.updated_at,
    g.last_seen
  FROM auth.users u
  LEFT JOIN public.admin_members am ON lower(am.email) = lower(u.email) AND am.is_active = true
  LEFT JOIN (
    SELECT gde.user_id, max(gde.created_at) AS last_seen 
    FROM public.greeting_display_events gde
    GROUP BY gde.user_id
  ) g ON g.user_id = u.id
  WHERE public.is_cue_admin() = true
  ORDER BY u.created_at DESC;
$$;

REVOKE ALL ON FUNCTION public.get_cue_members() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cue_members() TO authenticated, anon, project_admin;
