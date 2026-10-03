-- Fix is_cue_admin() by removing invalid UPDATE statement from STABLE function
-- Ensuring all 3 authorized admin accounts are recognized without read-only transaction errors.

-- 1. Create trigger function to keep admin_members.user_id synchronized cleanly on auth.users changes
CREATE OR REPLACE FUNCTION public.sync_admin_member_user_id()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
  UPDATE public.admin_members
  SET user_id = NEW.id, updated_at = now()
  WHERE lower(trim(email)) = lower(trim(NEW.email))
    AND (user_id IS NULL OR user_id <> NEW.id);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_sync_admin_member_user_id ON auth.users;
CREATE TRIGGER trg_sync_admin_member_user_id
AFTER INSERT OR UPDATE OF email ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.sync_admin_member_user_id();

-- 2. Synchronize all current admin members' user_id from auth.users right now
UPDATE public.admin_members am
SET user_id = u.id, updated_at = now()
FROM auth.users u
WHERE lower(trim(am.email)) = lower(trim(u.email))
  AND (am.user_id IS NULL OR am.user_id <> u.id);

-- 3. Replace is_cue_admin() with a purely read-only, robust STABLE function
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

  -- Authoritative email lookup from auth.users
  SELECT lower(trim(email)) INTO v_email
  FROM auth.users
  WHERE id = v_uid;

  -- Fallback to token email claim if auth.users lookup is empty
  IF v_email IS NULL OR v_email = '' THEN
    v_email := lower(trim(coalesce(auth.jwt() ->> 'email', '')));
  END IF;

  -- Strictly verify against the 3 authorized admin emails
  IF v_email NOT IN (
    'hersita04@gmail.com',
    'harshita301doc@gmail.com',
    'harsyng14@gmail.com'
  ) THEN
    RETURN false;
  END IF;

  -- Verify active record in admin_members matching email and uid
  RETURN EXISTS (
    SELECT 1
    FROM public.admin_members AS member
    WHERE member.is_active = true
      AND lower(trim(member.email)) = v_email
      AND (member.user_id IS NULL OR member.user_id = v_uid)
  );
END;
$$;

REVOKE ALL ON FUNCTION public.is_cue_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_cue_admin() TO authenticated, anon, project_admin;
