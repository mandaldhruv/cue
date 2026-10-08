-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 2 — SUPABASE MASTER DATABASE SCHEMA (SIMPLIFIED)
-- FILE: migration/supabase/stage-2-schema.sql
-- TARGET: Supabase PostgreSQL (Project ID: yxuxwcaldluhmteupzhp)
-- ARCHITECTURE: SIMPLIFIED PRODUCTION RUNTIME (10 TABLES, 0 BACKGROUND TELEMETRY)
-- ==============================================================================
-- ARCHITECTURAL DECISIONS INCORPORATED:
--  - Eliminated study telemetry, heartbeat tracking, and background timers.
--  - Eliminated database-driven greeting progress (greetings rendered client-side).
--  - Eliminated administrative notification panel system.
--  - Eliminated background dashboard polling and heavy telemetry queries.
--  - RETAINED: Core content (semesters, subjects, content_items, flashcards, pyqs)
--  - RETAINED: Admin authorization (is_cue_admin, admin_members, admin_activity)
--  - RETAINED: Student interaction (feedback_submissions, testimonials, admin_email_logs)
--  - RETAINED: Storage security helper functions (is_published_cue_pyq, etc.)
--
-- SAFETY GUARANTEES:
--  - ZERO destructive operations (NO DROP TABLE, TRUNCATE, DELETE, or UPDATE).
--  - ZERO production data modified or inserted.
--  - Complete search_path isolation on all SECURITY DEFINER functions.
--  - NO SQL HAS BEEN EXECUTED AGAINST SUPABASE YET.
-- ==============================================================================

-- ==============================================================================
-- 1. EXTENSIONS
-- ==============================================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;

-- ==============================================================================
-- 2. CORE UTILITY TRIGGER FUNCTION
-- Standard PostgreSQL updated_at trigger replacing InsForge internal trigger
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- ==============================================================================
-- 3. APPLICATION TABLES (10 CORE TABLES)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. SEMESTERS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.semesters (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_code text NOT NULL DEFAULT 'BMS',
  semester_number smallint NOT NULL CHECK (semester_number BETWEEN 1 AND 8),
  title text NOT NULL,
  status text NOT NULL DEFAULT 'coming_soon'
    CHECK (status IN ('draft', 'coming_soon', 'published', 'archived')),
  sort_order smallint NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT semesters_course_code_semester_number_key UNIQUE (course_code, semester_number)
);

-- ------------------------------------------------------------------------------
-- 2. SUBJECTS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.subjects (
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
  CONSTRAINT subjects_course_semester_slug_key UNIQUE (course_code, semester_number, slug)
);

CREATE INDEX IF NOT EXISTS subjects_published_sort_idx
  ON public.subjects (course_code, semester_number, sort_order)
  WHERE is_published = true;

-- ------------------------------------------------------------------------------
-- 3. FLASHCARD_UNITS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.flashcard_units (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id uuid NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  title text NOT NULL CHECK (char_length(btrim(title)) BETWEEN 1 AND 120),
  normalized_title text GENERATED ALWAYS AS (
    lower(regexp_replace(btrim(title), '\s+', ' ', 'g'))
  ) STORED,
  sort_order integer NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
  is_published boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT flashcard_units_subject_id_normalized_title_key UNIQUE (subject_id, normalized_title),
  CONSTRAINT flashcard_units_id_subject_id_key UNIQUE (id, subject_id)
);

CREATE INDEX IF NOT EXISTS flashcard_units_subject_sort_idx
  ON public.flashcard_units (subject_id, sort_order, title);

-- ------------------------------------------------------------------------------
-- 4. FLASHCARD_TOPICS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.flashcard_topics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id uuid NOT NULL,
  unit_id uuid NOT NULL,
  title text NOT NULL CHECK (char_length(btrim(title)) BETWEEN 1 AND 140),
  normalized_title text GENERATED ALWAYS AS (
    lower(regexp_replace(btrim(title), '\s+', ' ', 'g'))
  ) STORED,
  sort_order integer NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
  is_published boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT flashcard_topics_unit_subject_fkey
    FOREIGN KEY (unit_id, subject_id)
    REFERENCES public.flashcard_units(id, subject_id)
    ON DELETE CASCADE,
  CONSTRAINT flashcard_topics_unit_id_normalized_title_key UNIQUE (unit_id, normalized_title),
  CONSTRAINT flashcard_topics_id_unit_id_subject_id_key UNIQUE (id, unit_id, subject_id)
);

CREATE INDEX IF NOT EXISTS flashcard_topics_unit_sort_idx
  ON public.flashcard_topics (unit_id, sort_order, title);

-- ------------------------------------------------------------------------------
-- 5. CONTENT_ITEMS (Polymorphic: syllabus, notes, flashcards, pyqs)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.content_items (
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
  exam_type text NOT NULL DEFAULT 'University Exam',
  file_name text,
  file_size_bytes bigint CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
  submission_id uuid,
  flashcard_unit_id uuid,
  flashcard_topic_id uuid,
  question_document jsonb,
  answer_document jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT content_items_flashcard_unit_subject_fkey
    FOREIGN KEY (flashcard_unit_id, subject_id)
    REFERENCES public.flashcard_units(id, subject_id)
    ON DELETE CASCADE,
  CONSTRAINT content_items_flashcard_topic_scope_fkey
    FOREIGN KEY (flashcard_topic_id, flashcard_unit_id, subject_id)
    REFERENCES public.flashcard_topics(id, unit_id, subject_id)
    ON DELETE CASCADE,
  CONSTRAINT content_items_flashcard_hierarchy_check CHECK (
    content_type = 'flashcard'
    OR (flashcard_unit_id IS NULL AND flashcard_topic_id IS NULL
        AND question_document IS NULL AND answer_document IS NULL)
  )
);

CREATE INDEX IF NOT EXISTS content_items_subject_type_sort_idx
  ON public.content_items (subject_id, content_type, sort_order);

CREATE INDEX IF NOT EXISTS content_items_published_idx
  ON public.content_items (subject_id, content_type)
  WHERE is_published = true;

CREATE UNIQUE INDEX IF NOT EXISTS content_items_pyq_submission_unique
  ON public.content_items (submission_id)
  WHERE content_type = 'pyq' AND submission_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS content_items_flashcard_hierarchy_idx
  ON public.content_items (subject_id, flashcard_unit_id, flashcard_topic_id, sort_order)
  WHERE content_type = 'flashcard';

-- ------------------------------------------------------------------------------
-- 6. ADMIN_MEMBERS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.admin_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  display_name text NOT NULL DEFAULT '',
  role text NOT NULL DEFAULT 'editor' CHECK (role IN ('owner', 'editor')),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT admin_members_email_unique UNIQUE (email)
);

CREATE UNIQUE INDEX IF NOT EXISTS admin_members_user_id_unique
  ON public.admin_members (user_id) WHERE user_id IS NOT NULL;

-- ------------------------------------------------------------------------------
-- 7. ADMIN_ACTIVITY (Audit trail)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.admin_activity (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE RESTRICT,
  action text NOT NULL,
  entity_type text NOT NULL,
  entity_id uuid,
  summary text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS admin_activity_created_idx
  ON public.admin_activity (created_at DESC);

-- ------------------------------------------------------------------------------
-- 8. FEEDBACK_SUBMISSIONS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.feedback_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  submission_id uuid NOT NULL,
  rating smallint NOT NULL CHECK (rating BETWEEN 1 AND 5),
  category text NOT NULL CHECK (category IN (
    'Overall experience', 'Study content', 'Design & usability',
    'Feature request', 'Something else'
  )),
  message text NOT NULL CHECK (char_length(message) BETWEEN 10 AND 1000),
  student_year text NOT NULL CHECK (student_year = ANY (ARRAY[
    'First year'::text, 'Second year'::text, 'Third year'::text, 'Other'::text,
    'Student'::text, 'Professor / Educator'::text, 'Professor / Teacher'::text
  ])),
  email text,
  is_content_issue boolean NOT NULL DEFAULT false,
  status text NOT NULL DEFAULT 'new' CHECK (status IN (
    'new', 'reviewed', 'resolved', 'archived'
  )),
  admin_note text NOT NULL DEFAULT '',
  user_id uuid,
  user_name text,
  role text,
  is_published boolean DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT feedback_submissions_submission_id_key UNIQUE (submission_id)
);

CREATE INDEX IF NOT EXISTS feedback_submissions_status_created_idx
  ON public.feedback_submissions (status, created_at DESC);

CREATE INDEX IF NOT EXISTS feedback_submissions_category_idx
  ON public.feedback_submissions (category);

CREATE INDEX IF NOT EXISTS feedback_submissions_user_id_idx
  ON public.feedback_submissions (user_id);

CREATE INDEX IF NOT EXISTS feedback_submissions_is_published_idx
  ON public.feedback_submissions (is_published);

-- ------------------------------------------------------------------------------
-- 9. TESTIMONIALS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.testimonials (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  feedback_id uuid,
  person_name text NOT NULL,
  designation text NOT NULL,
  institution text NOT NULL DEFAULT '',
  quote text NOT NULL CHECK (char_length(quote) >= 10 AND char_length(quote) <= 1200),
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
  CONSTRAINT testimonials_feedback_id_key UNIQUE (feedback_id),
  CONSTRAINT testimonials_check CHECK (NOT is_published OR consent_confirmed)
);

CREATE INDEX IF NOT EXISTS testimonials_published_sort_idx
  ON public.testimonials (is_featured DESC, sort_order, created_at DESC)
  WHERE is_published = true;

CREATE INDEX IF NOT EXISTS testimonials_feedback_id_idx
  ON public.testimonials (feedback_id);

-- ------------------------------------------------------------------------------
-- 10. ADMIN_EMAIL_LOGS (Transactional email deduplication)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.admin_email_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type text NOT NULL,
  related_id text NOT NULL,
  recipient text NOT NULL,
  subject text NOT NULL,
  status text NOT NULL DEFAULT 'sent',
  error_message text,
  sent_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS admin_email_logs_dedup_idx
  ON public.admin_email_logs (event_type, related_id);

-- ==============================================================================
-- 4. POSTGRESQL FUNCTIONS & RPCS
-- ==============================================================================

-- 1. IS_CUE_ADMIN
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

  SELECT lower(trim(email)) INTO v_email
  FROM auth.users
  WHERE id = v_uid;

  IF v_email IS NULL OR v_email = '' THEN
    v_email := lower(trim(coalesce(auth.jwt() ->> 'email', '')));
  END IF;

  IF v_email NOT IN (
    'hersita04@gmail.com',
    'harshita301doc@gmail.com',
    'harsyng14@gmail.com'
  ) THEN
    RETURN false;
  END IF;

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

-- 2. GET_CUE_MEMBERS (Streamlined member roster; zero telemetry joins)
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

-- 3. STORAGE ACCESS HELPERS
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

-- ==============================================================================
-- 5. TRIGGERS & TRIGGER FUNCTIONS
-- ==============================================================================

-- 1. UPDATED_AT TRIGGERS (8 Mutable Tables)
DROP TRIGGER IF EXISTS semesters_set_updated_at ON public.semesters;
CREATE TRIGGER semesters_set_updated_at
BEFORE UPDATE ON public.semesters
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS subjects_set_updated_at ON public.subjects;
CREATE TRIGGER subjects_set_updated_at
BEFORE UPDATE ON public.subjects
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS flashcard_units_set_updated_at ON public.flashcard_units;
CREATE TRIGGER flashcard_units_set_updated_at
BEFORE UPDATE ON public.flashcard_units
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS flashcard_topics_set_updated_at ON public.flashcard_topics;
CREATE TRIGGER flashcard_topics_set_updated_at
BEFORE UPDATE ON public.flashcard_topics
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS content_items_set_updated_at ON public.content_items;
CREATE TRIGGER content_items_set_updated_at
BEFORE UPDATE ON public.content_items
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS admin_members_set_updated_at ON public.admin_members;
CREATE TRIGGER admin_members_set_updated_at
BEFORE UPDATE ON public.admin_members
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS feedback_submissions_set_updated_at ON public.feedback_submissions;
CREATE TRIGGER feedback_submissions_set_updated_at
BEFORE UPDATE ON public.feedback_submissions
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS testimonials_set_updated_at ON public.testimonials;
CREATE TRIGGER testimonials_set_updated_at
BEFORE UPDATE ON public.testimonials
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 2. AUTH.USERS -> ADMIN_MEMBERS SYNCHRONIZATION TRIGGER
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

-- ==============================================================================
-- 6. ROW LEVEL SECURITY (RLS) POLICIES & TABLE GRANTS
-- ==============================================================================

-- 1. SEMESTERS
ALTER TABLE public.semesters ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.semesters FROM anon, authenticated;
GRANT SELECT ON TABLE public.semesters TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.semesters TO authenticated;

DROP POLICY IF EXISTS "public semesters are readable" ON public.semesters;
CREATE POLICY "public semesters are readable"
  ON public.semesters FOR SELECT TO anon, authenticated
  USING (status = ANY (ARRAY['coming_soon'::text, 'published'::text]));

DROP POLICY IF EXISTS "admins can read all semesters" ON public.semesters;
CREATE POLICY "admins can read all semesters"
  ON public.semesters FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can create semesters" ON public.semesters;
CREATE POLICY "admins can create semesters"
  ON public.semesters FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can update semesters" ON public.semesters;
CREATE POLICY "admins can update semesters"
  ON public.semesters FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can delete semesters" ON public.semesters;
CREATE POLICY "admins can delete semesters"
  ON public.semesters FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- 2. SUBJECTS
ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.subjects FROM anon, authenticated;
GRANT SELECT ON TABLE public.subjects TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.subjects TO authenticated;

DROP POLICY IF EXISTS "published subjects are publicly readable" ON public.subjects;
CREATE POLICY "published subjects are publicly readable"
  ON public.subjects FOR SELECT TO anon, authenticated
  USING (is_published = true);

DROP POLICY IF EXISTS "admins can read all subjects" ON public.subjects;
CREATE POLICY "admins can read all subjects"
  ON public.subjects FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can create subjects" ON public.subjects;
CREATE POLICY "admins can create subjects"
  ON public.subjects FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can update subjects" ON public.subjects;
CREATE POLICY "admins can update subjects"
  ON public.subjects FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can delete subjects" ON public.subjects;
CREATE POLICY "admins can delete subjects"
  ON public.subjects FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- 3. FLASHCARD_UNITS
ALTER TABLE public.flashcard_units ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.flashcard_units FROM anon, authenticated;
GRANT SELECT ON TABLE public.flashcard_units TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.flashcard_units TO authenticated;

DROP POLICY IF EXISTS "published flashcard units are publicly readable" ON public.flashcard_units;
CREATE POLICY "published flashcard units are publicly readable"
  ON public.flashcard_units FOR SELECT TO anon, authenticated
  USING (is_published = true);

DROP POLICY IF EXISTS "admins can read all flashcard units" ON public.flashcard_units;
CREATE POLICY "admins can read all flashcard units"
  ON public.flashcard_units FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can create flashcard units" ON public.flashcard_units;
CREATE POLICY "admins can create flashcard units"
  ON public.flashcard_units FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can update flashcard units" ON public.flashcard_units;
CREATE POLICY "admins can update flashcard units"
  ON public.flashcard_units FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can delete flashcard units" ON public.flashcard_units;
CREATE POLICY "admins can delete flashcard units"
  ON public.flashcard_units FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- 4. FLASHCARD_TOPICS
ALTER TABLE public.flashcard_topics ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.flashcard_topics FROM anon, authenticated;
GRANT SELECT ON TABLE public.flashcard_topics TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.flashcard_topics TO authenticated;

DROP POLICY IF EXISTS "published flashcard topics are publicly readable" ON public.flashcard_topics;
CREATE POLICY "published flashcard topics are publicly readable"
  ON public.flashcard_topics FOR SELECT TO anon, authenticated
  USING (is_published = true);

DROP POLICY IF EXISTS "admins can read all flashcard topics" ON public.flashcard_topics;
CREATE POLICY "admins can read all flashcard topics"
  ON public.flashcard_topics FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can create flashcard topics" ON public.flashcard_topics;
CREATE POLICY "admins can create flashcard topics"
  ON public.flashcard_topics FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can update flashcard topics" ON public.flashcard_topics;
CREATE POLICY "admins can update flashcard topics"
  ON public.flashcard_topics FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can delete flashcard topics" ON public.flashcard_topics;
CREATE POLICY "admins can delete flashcard topics"
  ON public.flashcard_topics FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- 5. CONTENT_ITEMS
ALTER TABLE public.content_items ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.content_items FROM anon, authenticated;
GRANT SELECT ON TABLE public.content_items TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.content_items TO authenticated;

DROP POLICY IF EXISTS "published content is publicly readable" ON public.content_items;
CREATE POLICY "published content is publicly readable"
  ON public.content_items FOR SELECT TO anon, authenticated
  USING (is_published = true);

DROP POLICY IF EXISTS "admins can read all content" ON public.content_items;
CREATE POLICY "admins can read all content"
  ON public.content_items FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can create content" ON public.content_items;
CREATE POLICY "admins can create content"
  ON public.content_items FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can update content" ON public.content_items;
CREATE POLICY "admins can update content"
  ON public.content_items FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can delete content" ON public.content_items;
CREATE POLICY "admins can delete content"
  ON public.content_items FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- 6. ADMIN_MEMBERS
ALTER TABLE public.admin_members ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_members FROM anon, authenticated;
GRANT SELECT ON TABLE public.admin_members TO authenticated;

DROP POLICY IF EXISTS "admins can read admin membership" ON public.admin_members;
CREATE POLICY "admins can read admin membership"
  ON public.admin_members FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- 7. ADMIN_ACTIVITY
ALTER TABLE public.admin_activity ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_activity FROM anon, authenticated;
GRANT SELECT, INSERT ON TABLE public.admin_activity TO authenticated;

DROP POLICY IF EXISTS "admins can read activity" ON public.admin_activity;
CREATE POLICY "admins can read activity"
  ON public.admin_activity FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can record activity" ON public.admin_activity;
CREATE POLICY "admins can record activity"
  ON public.admin_activity FOR INSERT TO authenticated
  WITH CHECK (
    (SELECT public.is_cue_admin())
    AND (admin_user_id = (SELECT auth.uid()))
  );

-- 8. FEEDBACK_SUBMISSIONS
ALTER TABLE public.feedback_submissions ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.feedback_submissions FROM anon, authenticated;
GRANT INSERT ON TABLE public.feedback_submissions TO anon, authenticated;
GRANT SELECT, UPDATE, DELETE ON TABLE public.feedback_submissions TO authenticated;

DROP POLICY IF EXISTS "students can submit private feedback" ON public.feedback_submissions;
CREATE POLICY "students can submit private feedback"
  ON public.feedback_submissions FOR INSERT TO anon, authenticated
  WITH CHECK (
    status = 'new'::text
    AND admin_note = ''::text
  );

DROP POLICY IF EXISTS "admins can read feedback" ON public.feedback_submissions;
CREATE POLICY "admins can read feedback"
  ON public.feedback_submissions FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can update feedback" ON public.feedback_submissions;
CREATE POLICY "admins can update feedback"
  ON public.feedback_submissions FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can delete feedback" ON public.feedback_submissions;
CREATE POLICY "admins can delete feedback"
  ON public.feedback_submissions FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- 9. TESTIMONIALS
ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.testimonials FROM anon, authenticated;
GRANT SELECT ON TABLE public.testimonials TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.testimonials TO authenticated;

DROP POLICY IF EXISTS "published testimonials are publicly readable" ON public.testimonials;
CREATE POLICY "published testimonials are publicly readable"
  ON public.testimonials FOR SELECT TO anon, authenticated
  USING (is_published = true);

DROP POLICY IF EXISTS "admins can read all testimonials" ON public.testimonials;
CREATE POLICY "admins can read all testimonials"
  ON public.testimonials FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can create testimonials" ON public.testimonials;
CREATE POLICY "admins can create testimonials"
  ON public.testimonials FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can update testimonials" ON public.testimonials;
CREATE POLICY "admins can update testimonials"
  ON public.testimonials FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "admins can delete testimonials" ON public.testimonials;
CREATE POLICY "admins can delete testimonials"
  ON public.testimonials FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- 10. ADMIN_EMAIL_LOGS
ALTER TABLE public.admin_email_logs ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_email_logs FROM anon, authenticated;
GRANT SELECT ON TABLE public.admin_email_logs TO authenticated;

DROP POLICY IF EXISTS "Admins can view email logs" ON public.admin_email_logs;
CREATE POLICY "Admins can view email logs"
  ON public.admin_email_logs FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- ==============================================================================
-- 5. STORAGE BUCKET CONFIGURATIONS & STORAGE RLS POLICIES
-- ==============================================================================

-- 1. PROVISION STORAGE BUCKETS (If not already present)
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

-- 2. STORAGE RLS: CUE-PYQS
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

-- 3. STORAGE RLS: CUE-TESTIMONIALS
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

-- 4. STORAGE RLS: CUE-FLASHCARDS
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

-- ==============================================================================
-- END OF SIMPLIFIED STAGE 2 SCHEMA MIGRATION PACKAGE
-- ==============================================================================
