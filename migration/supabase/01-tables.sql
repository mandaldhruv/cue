-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 2 — SUPABASE DATABASE SCHEMA (SIMPLIFIED)
-- PART 1: EXTENSIONS, UTILITIES, TABLES, CONSTRAINTS & INDEXES
-- ==============================================================================
-- Notice:
--  - Zero dead telemetry, background tracking, or notification tables.
--  - Exactly 10 production tables representing Cue's core domain.
--  - No destructive commands (NO DROP TABLE, TRUNCATE, DELETE, UPDATE).
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;

-- 2. UPDATED_AT TRIGGER FUNCTION
-- Standard PostgreSQL implementation replacing InsForge internal trigger
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

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
