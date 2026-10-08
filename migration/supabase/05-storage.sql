-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 2 — SUPABASE DATABASE SCHEMA
-- PART 5: STORAGE BUCKET CONFIGURATIONS & STORAGE RLS POLICIES
-- ==============================================================================
-- Target: Supabase Storage engine (`storage.buckets` & `storage.objects`).
-- Supabase Schema Mapping:
--   InsForge `bucket`       -> Supabase `bucket_id`
--   InsForge `key`          -> Supabase `name`
--   InsForge `uploaded_by`  -> Supabase `owner`
-- Notice: Stage 2B storage deployment.
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. PROVISION STORAGE BUCKETS (If not already present)
-- ------------------------------------------------------------------------------
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  (
    'cue-pyqs',
    'cue-pyqs',
    false,
    26214400, -- 25MB max
    ARRAY['application/pdf']
  ),
  (
    'cue-testimonials',
    'cue-testimonials',
    false,
    5242880, -- 5MB max
    ARRAY['image/jpeg', 'image/png', 'image/webp']
  ),
  (
    'cue-flashcards',
    'cue-flashcards',
    false,
    5242880, -- 5MB max
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
  )
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- ------------------------------------------------------------------------------
-- 2. STORAGE RLS: CUE-PYQS
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS cue_pyqs_published_read ON storage.objects;
CREATE POLICY cue_pyqs_published_read
  ON storage.objects FOR SELECT TO anon, authenticated
  USING (
    bucket_id = 'cue-pyqs'
    AND (SELECT public.is_published_cue_pyq(name))
  );

DROP POLICY IF EXISTS cue_pyqs_admin_read ON storage.objects;
CREATE POLICY cue_pyqs_admin_read
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'cue-pyqs'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_pyqs_admin_insert ON storage.objects;
CREATE POLICY cue_pyqs_admin_insert
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'cue-pyqs'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_pyqs_admin_update ON storage.objects;
CREATE POLICY cue_pyqs_admin_update
  ON storage.objects FOR UPDATE TO authenticated
  USING (
    bucket_id = 'cue-pyqs'
    AND (SELECT public.is_cue_admin())
  )
  WITH CHECK (
    bucket_id = 'cue-pyqs'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_pyqs_admin_delete ON storage.objects;
CREATE POLICY cue_pyqs_admin_delete
  ON storage.objects FOR DELETE TO authenticated
  USING (
    bucket_id = 'cue-pyqs'
    AND (SELECT public.is_cue_admin())
  );

-- ------------------------------------------------------------------------------
-- 3. STORAGE RLS: CUE-TESTIMONIALS
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS cue_testimonials_published_read ON storage.objects;
CREATE POLICY cue_testimonials_published_read
  ON storage.objects FOR SELECT TO anon, authenticated
  USING (
    bucket_id = 'cue-testimonials'
    AND (SELECT public.is_published_cue_testimonial(name))
  );

DROP POLICY IF EXISTS cue_testimonials_admin_read ON storage.objects;
CREATE POLICY cue_testimonials_admin_read
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'cue-testimonials'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_testimonials_admin_insert ON storage.objects;
CREATE POLICY cue_testimonials_admin_insert
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'cue-testimonials'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_testimonials_admin_update ON storage.objects;
CREATE POLICY cue_testimonials_admin_update
  ON storage.objects FOR UPDATE TO authenticated
  USING (
    bucket_id = 'cue-testimonials'
    AND (SELECT public.is_cue_admin())
  )
  WITH CHECK (
    bucket_id = 'cue-testimonials'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_testimonials_admin_delete ON storage.objects;
CREATE POLICY cue_testimonials_admin_delete
  ON storage.objects FOR DELETE TO authenticated
  USING (
    bucket_id = 'cue-testimonials'
    AND (SELECT public.is_cue_admin())
  );

-- ------------------------------------------------------------------------------
-- 4. STORAGE RLS: CUE-FLASHCARDS
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS cue_flashcards_published_read ON storage.objects;
CREATE POLICY cue_flashcards_published_read
  ON storage.objects FOR SELECT TO anon, authenticated
  USING (
    bucket_id = 'cue-flashcards'
    AND (SELECT public.is_published_cue_flashcard_media(name))
  );

DROP POLICY IF EXISTS cue_flashcards_admin_read ON storage.objects;
CREATE POLICY cue_flashcards_admin_read
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'cue-flashcards'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_flashcards_admin_insert ON storage.objects;
CREATE POLICY cue_flashcards_admin_insert
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'cue-flashcards'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_flashcards_admin_update ON storage.objects;
CREATE POLICY cue_flashcards_admin_update
  ON storage.objects FOR UPDATE TO authenticated
  USING (
    bucket_id = 'cue-flashcards'
    AND (SELECT public.is_cue_admin())
  )
  WITH CHECK (
    bucket_id = 'cue-flashcards'
    AND (SELECT public.is_cue_admin())
  );

DROP POLICY IF EXISTS cue_flashcards_admin_delete ON storage.objects;
CREATE POLICY cue_flashcards_admin_delete
  ON storage.objects FOR DELETE TO authenticated
  USING (
    bucket_id = 'cue-flashcards'
    AND (SELECT public.is_cue_admin())
  );
