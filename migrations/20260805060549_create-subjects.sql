CREATE TABLE public.subjects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL,
  short_code text NOT NULL,
  course_code text NOT NULL DEFAULT 'BMS',
  semester_number smallint NOT NULL CHECK (semester_number BETWEEN 1 AND 8),
  description text NOT NULL DEFAULT '',
  accent_color text NOT NULL DEFAULT '#315DE6'
    CHECK (accent_color ~ '^#[0-9A-Fa-f]{6}$'),
  units_count smallint NOT NULL DEFAULT 0 CHECK (units_count >= 0),
  resources_count integer NOT NULL DEFAULT 0 CHECK (resources_count >= 0),
  sort_order smallint NOT NULL DEFAULT 0,
  is_published boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT subjects_course_semester_slug_key
    UNIQUE (course_code, semester_number, slug)
);

CREATE INDEX subjects_published_sort_idx
  ON public.subjects (course_code, semester_number, sort_order)
  WHERE is_published = true;

CREATE TRIGGER subjects_set_updated_at
  BEFORE UPDATE ON public.subjects
  FOR EACH ROW
  EXECUTE FUNCTION system.update_updated_at();

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.subjects FROM anon, authenticated;
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON TABLE public.subjects TO anon, authenticated;

CREATE POLICY "published subjects are publicly readable"
  ON public.subjects
  FOR SELECT
  TO anon, authenticated
  USING (is_published = true);
