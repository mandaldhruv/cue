-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 2 — SUPABASE DATABASE SCHEMA (SIMPLIFIED)
-- PART 2: POSTGRESQL FUNCTIONS & RPCS
-- ==============================================================================
-- Architectural Simplification:
--  - Eliminated legacy study tracking, telemetry, and background session functions.
--  - Eliminated database-driven greeting reservation (greetings are client/deterministic).
--  - Eliminated notification panel functions (notification bell removed from UI).
--  - RETAINED & STREAMLINED:
--      1. is_cue_admin() -> Authoritative admin check
--      2. get_cue_members() -> Fast member roster without heavy joins
--      3. is_published_cue_pyq() -> Storage RLS helper
--      4. is_published_cue_testimonial() -> Storage RLS helper
--      5. is_published_cue_flashcard_media() -> Storage RLS helper
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. IS_CUE_ADMIN: Authoritative admin authorization check
-- ------------------------------------------------------------------------------
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
GRANT EXECUTE ON FUNCTION public.is_cue_admin() TO authenticated, anon;

-- ------------------------------------------------------------------------------
-- 2. GET_CUE_MEMBERS: Streamlined member roster (No heavy telemetry joins)
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_cue_members()
RETURNS TABLE (
  id uuid,
  email text,
  name text,
  role text,
  email_verified boolean,
  created_at timestamptz,
  updated_at timestamptz,
  last_sign_in_at timestamptz,
  last_seen timestamptz
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
    COALESCE(u.email, '')::text AS email,
    COALESCE(
      NULLIF(trim(u.raw_user_meta_data->>'name'), ''),
      split_part(COALESCE(u.email, 'member@cue.study'), '@', 1)
    )::text AS name,
    CASE 
      WHEN lower(u.email) IN (
        'hersita04@gmail.com',
        'harshita301doc@gmail.com',
        'harsyng14@gmail.com'
      ) THEN 'Admin (owner)'
      WHEN am.role IS NOT NULL THEN 'Admin (' || am.role || ')'
      ELSE 'Student'
    END::text AS role,
    (u.email_confirmed_at IS NOT NULL) AS email_verified,
    u.created_at,
    u.updated_at,
    u.last_sign_in_at,
    COALESCE(u.last_sign_in_at, u.created_at) AS last_seen
  FROM auth.users u
  LEFT JOIN public.admin_members am ON lower(am.email) = lower(u.email) AND am.is_active = true
  ORDER BY u.created_at DESC;
END;
$$;

REVOKE ALL ON FUNCTION public.get_cue_members() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cue_members() TO authenticated;

-- ------------------------------------------------------------------------------
-- 3. STORAGE ACCESS HELPER FUNCTIONS
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_published_cue_pyq(object_key text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.content_items
    WHERE content_type = 'pyq'
      AND is_published = true
      AND file_key = object_key
  );
$$;

REVOKE ALL ON FUNCTION public.is_published_cue_pyq(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_published_cue_pyq(text) TO anon, authenticated;

CREATE OR REPLACE FUNCTION public.is_published_cue_testimonial(object_key text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.testimonials
    WHERE is_published = true
      AND consent_confirmed = true
      AND headshot_key = object_key
  );
$$;

REVOKE ALL ON FUNCTION public.is_published_cue_testimonial(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_published_cue_testimonial(text) TO anon, authenticated;

CREATE OR REPLACE FUNCTION public.is_published_cue_flashcard_media(object_key text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.content_items
    WHERE content_type = 'flashcard'
      AND is_published = true
      AND (
        position(to_jsonb(object_key)::text in coalesce(question_document::text, '')) > 0
        OR position(to_jsonb(object_key)::text in coalesce(answer_document::text, '')) > 0
      )
  );
$$;

REVOKE ALL ON FUNCTION public.is_published_cue_flashcard_media(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_published_cue_flashcard_media(text) TO anon, authenticated;
