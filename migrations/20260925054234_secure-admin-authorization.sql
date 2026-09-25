-- Security Fix: Restrict admin authorization to explicitly authorized emails only
-- 1. hersita04@gmail.com
-- 2. harshita301doc@gmail.com

-- Ensure admin_members contains only the authorized admin accounts
DELETE FROM public.admin_members
WHERE lower(email) NOT IN ('hersita04@gmail.com', 'harshita301doc@gmail.com');

INSERT INTO public.admin_members (email, display_name, role, is_active)
VALUES
  ('hersita04@gmail.com', 'Harshita Singh', 'owner', true),
  ('harshita301doc@gmail.com', 'Harshita Singh', 'owner', true)
ON CONFLICT (email) DO UPDATE SET is_active = true, role = 'owner';

-- Link user_id from auth.users for existing accounts
UPDATE public.admin_members am
SET user_id = u.id
FROM auth.users u
WHERE lower(am.email) = lower(u.email);

-- Fix public.is_cue_admin() to strictly verify authenticated session and authorized email
CREATE OR REPLACE FUNCTION public.is_cue_admin()
RETURNS boolean
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
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
  IF v_email NOT IN ('hersita04@gmail.com', 'harshita301doc@gmail.com') THEN
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
GRANT EXECUTE ON FUNCTION public.is_cue_admin() TO authenticated, anon;

-- Update get_cue_members to require admin authorization and prevent leaking member data
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
    g.last_seen
  FROM auth.users u
  LEFT JOIN public.admin_members am ON lower(am.email) = lower(u.email) AND am.is_active = true
  LEFT JOIN (
    SELECT gde.user_id, max(gde.created_at) AS last_seen 
    FROM public.greeting_display_events gde
    GROUP BY gde.user_id
  ) g ON g.user_id = u.id
  ORDER BY u.created_at DESC;
END;
$$;

REVOKE ALL ON FUNCTION public.get_cue_members() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cue_members() TO authenticated;
