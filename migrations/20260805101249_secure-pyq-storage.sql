ALTER TABLE public.content_items
  ADD COLUMN exam_type text NOT NULL DEFAULT 'University Exam',
  ADD COLUMN file_name text,
  ADD COLUMN file_size_bytes bigint CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0);

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

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

CREATE POLICY cue_pyqs_published_read
  ON storage.objects FOR SELECT TO anon, authenticated
  USING (
    bucket = 'cue-pyqs'
    AND (SELECT public.is_published_cue_pyq(key))
  );

CREATE POLICY cue_pyqs_admin_read
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket = 'cue-pyqs'
    AND (SELECT public.is_cue_admin())
  );

CREATE POLICY cue_pyqs_admin_insert
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket = 'cue-pyqs'
    AND uploaded_by = (SELECT auth.jwt() ->> 'sub')
    AND (SELECT public.is_cue_admin())
  );

CREATE POLICY cue_pyqs_admin_update
  ON storage.objects FOR UPDATE TO authenticated
  USING (bucket = 'cue-pyqs' AND (SELECT public.is_cue_admin()))
  WITH CHECK (bucket = 'cue-pyqs' AND (SELECT public.is_cue_admin()));

CREATE POLICY cue_pyqs_admin_delete
  ON storage.objects FOR DELETE TO authenticated
  USING (bucket = 'cue-pyqs' AND (SELECT public.is_cue_admin()));

GRANT USAGE ON SCHEMA storage TO anon, authenticated;
GRANT SELECT ON storage.objects TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON storage.objects TO authenticated;
