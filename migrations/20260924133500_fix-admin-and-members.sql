-- Fix is_cue_admin and get_cue_members to ensure all members are reliably visible to admins

CREATE OR REPLACE FUNCTION public.is_cue_admin()
RETURNS boolean
LANGUAGE sql
STABLE SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
  SELECT (
    -- Direct project_admin connection
    current_user = 'project_admin'
    OR
    -- Check admin_members table
    EXISTS (
      SELECT 1
      FROM public.admin_members AS member
      WHERE member.is_active = true
        AND (
          (member.user_id IS NOT NULL AND member.user_id = (SELECT auth.uid()))
          OR
          (auth.jwt() ->> 'email' IS NOT NULL AND lower(member.email) = lower(auth.jwt() ->> 'email'))
          OR
          EXISTS (
            SELECT 1 FROM auth.users AS u
            WHERE u.id = (SELECT auth.uid())
              AND lower(u.email) = lower(member.email)
          )
        )
    )
    OR
    -- Check is_project_admin flag in auth.users
    EXISTS (
      SELECT 1
      FROM auth.users AS account
      WHERE account.id = (SELECT auth.uid())
        AND account.is_project_admin = true
    )
  );
$$;

REVOKE ALL ON FUNCTION public.is_cue_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_cue_admin() TO authenticated, anon, project_admin;

-- Ensure all admin email variations are registered in admin_members
INSERT INTO public.admin_members (email, display_name, role, is_active)
VALUES 
  ('hersita04@gmail.com', 'Harshita Singh', 'owner', true),
  ('harshita301doc@gmail.com', 'Harshita Singh', 'owner', true),
  ('harsyng14@gmail.com', 'Dhruv', 'owner', true),
  ('mandal.dhruv@dypic.in', 'Dhruv Mandal', 'owner', true)
ON CONFLICT (email) DO UPDATE SET is_active = true;

-- Update get_cue_members RPC function
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
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  RETURN QUERY
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
    SELECT user_id, max(created_at) AS last_seen 
    FROM public.greeting_display_events 
    GROUP BY user_id
  ) g ON g.user_id = u.id
  ORDER BY u.created_at DESC;
END;
$$;

REVOKE ALL ON FUNCTION public.get_cue_members() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cue_members() TO authenticated, anon, project_admin;
