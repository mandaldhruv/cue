CREATE TABLE public.semesters (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_code text NOT NULL DEFAULT 'BMS',
  semester_number smallint NOT NULL CHECK (semester_number BETWEEN 1 AND 8),
  title text NOT NULL,
  status text NOT NULL DEFAULT 'coming_soon'
    CHECK (status IN ('draft', 'coming_soon', 'published', 'archived')),
  sort_order smallint NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (course_code, semester_number)
);

CREATE TABLE public.content_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id uuid NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  content_type text NOT NULL CHECK (content_type IN (
    'syllabus_unit', 'note', 'flashcard', 'pyq', 'important_topic', 'recommended_resource'
  )),
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  body text NOT NULL DEFAULT '',
  academic_year smallint,
  file_url text,
  file_key text,
  sort_order integer NOT NULL DEFAULT 0,
  is_published boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX content_items_subject_type_sort_idx
  ON public.content_items (subject_id, content_type, sort_order);
CREATE INDEX content_items_published_idx
  ON public.content_items (subject_id, content_type)
  WHERE is_published = true;

CREATE TRIGGER semesters_set_updated_at
  BEFORE UPDATE ON public.semesters
  FOR EACH ROW EXECUTE FUNCTION system.update_updated_at();
CREATE TRIGGER content_items_set_updated_at
  BEFORE UPDATE ON public.content_items
  FOR EACH ROW EXECUTE FUNCTION system.update_updated_at();

ALTER TABLE public.semesters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_items ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.semesters, public.content_items FROM anon, authenticated;
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON TABLE public.semesters, public.content_items TO anon, authenticated;

CREATE POLICY "public semesters are readable"
  ON public.semesters FOR SELECT TO anon, authenticated
  USING (status IN ('coming_soon', 'published'));

CREATE POLICY "published content is publicly readable"
  ON public.content_items FOR SELECT TO anon, authenticated
  USING (is_published = true);

INSERT INTO public.semesters (course_code, semester_number, title, status, sort_order)
VALUES
  ('BMS', 1, 'Semester 1', 'coming_soon', 1),
  ('BMS', 2, 'Semester 2', 'coming_soon', 2),
  ('BMS', 3, 'Semester 3', 'published', 3),
  ('BMS', 4, 'Semester 4', 'coming_soon', 4),
  ('BMS', 5, 'Semester 5', 'coming_soon', 5),
  ('BMS', 6, 'Semester 6', 'coming_soon', 6);
