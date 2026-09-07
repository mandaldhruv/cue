ALTER TABLE public.content_items
  ADD COLUMN submission_id uuid;

CREATE UNIQUE INDEX content_items_pyq_submission_unique
  ON public.content_items (submission_id)
  WHERE content_type = 'pyq' AND submission_id IS NOT NULL;

CREATE TABLE public.feedback_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  submission_id uuid NOT NULL UNIQUE,
  rating smallint NOT NULL CHECK (rating BETWEEN 1 AND 5),
  category text NOT NULL CHECK (category IN (
    'Overall experience', 'Study content', 'Design & usability',
    'Feature request', 'Something else'
  )),
  message text NOT NULL CHECK (char_length(message) BETWEEN 10 AND 1000),
  student_year text NOT NULL CHECK (student_year IN (
    'First year', 'Second year', 'Third year', 'Other'
  )),
  email text,
  is_content_issue boolean NOT NULL DEFAULT false,
  status text NOT NULL DEFAULT 'new' CHECK (status IN (
    'new', 'reviewed', 'resolved', 'archived'
  )),
  admin_note text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX feedback_submissions_status_created_idx
  ON public.feedback_submissions (status, created_at DESC);
CREATE INDEX feedback_submissions_category_idx
  ON public.feedback_submissions (category);

CREATE TRIGGER feedback_submissions_set_updated_at
  BEFORE UPDATE ON public.feedback_submissions
  FOR EACH ROW EXECUTE FUNCTION system.update_updated_at();

CREATE TABLE public.testimonials (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  person_name text NOT NULL,
  designation text NOT NULL,
  institution text NOT NULL DEFAULT '',
  quote text NOT NULL CHECK (char_length(quote) BETWEEN 20 AND 1200),
  headshot_url text,
  headshot_key text,
  image_alt text NOT NULL DEFAULT '',
  rating smallint NOT NULL DEFAULT 5 CHECK (rating BETWEEN 1 AND 5),
  is_featured boolean NOT NULL DEFAULT false,
  is_published boolean NOT NULL DEFAULT false,
  consent_confirmed boolean NOT NULL DEFAULT false,
  consent_note text NOT NULL DEFAULT '',
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CHECK (NOT is_published OR consent_confirmed)
);

CREATE INDEX testimonials_published_sort_idx
  ON public.testimonials (is_featured DESC, sort_order, created_at DESC)
  WHERE is_published = true;

CREATE TRIGGER testimonials_set_updated_at
  BEFORE UPDATE ON public.testimonials
  FOR EACH ROW EXECUTE FUNCTION system.update_updated_at();

ALTER TABLE public.feedback_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.feedback_submissions, public.testimonials FROM anon, authenticated;
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT INSERT ON TABLE public.feedback_submissions TO anon, authenticated;
GRANT SELECT, UPDATE, DELETE ON TABLE public.feedback_submissions TO authenticated;
GRANT SELECT ON TABLE public.testimonials TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.testimonials TO authenticated;

CREATE POLICY "students can submit private feedback"
  ON public.feedback_submissions FOR INSERT TO anon, authenticated
  WITH CHECK (
    status = 'new'
    AND admin_note = ''
  );

CREATE POLICY "admins can read feedback"
  ON public.feedback_submissions FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can update feedback"
  ON public.feedback_submissions FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can delete feedback"
  ON public.feedback_submissions FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

CREATE POLICY "published testimonials are publicly readable"
  ON public.testimonials FOR SELECT TO anon, authenticated
  USING (is_published = true);
CREATE POLICY "admins can read all testimonials"
  ON public.testimonials FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can create testimonials"
  ON public.testimonials FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can update testimonials"
  ON public.testimonials FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can delete testimonials"
  ON public.testimonials FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

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

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

CREATE POLICY cue_testimonials_published_read
  ON storage.objects FOR SELECT TO anon, authenticated
  USING (
    bucket = 'cue-testimonials'
    AND (SELECT public.is_published_cue_testimonial(key))
  );
CREATE POLICY cue_testimonials_admin_read
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket = 'cue-testimonials'
    AND (SELECT public.is_cue_admin())
  );
CREATE POLICY cue_testimonials_admin_insert
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket = 'cue-testimonials'
    AND uploaded_by = (SELECT auth.jwt() ->> 'sub')
    AND (SELECT public.is_cue_admin())
  );
CREATE POLICY cue_testimonials_admin_update
  ON storage.objects FOR UPDATE TO authenticated
  USING (bucket = 'cue-testimonials' AND (SELECT public.is_cue_admin()))
  WITH CHECK (bucket = 'cue-testimonials' AND (SELECT public.is_cue_admin()));
CREATE POLICY cue_testimonials_admin_delete
  ON storage.objects FOR DELETE TO authenticated
  USING (bucket = 'cue-testimonials' AND (SELECT public.is_cue_admin()));

GRANT USAGE ON SCHEMA storage TO anon, authenticated;
GRANT SELECT ON storage.objects TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON storage.objects TO authenticated;
