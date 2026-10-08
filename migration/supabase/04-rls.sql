-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 2 — SUPABASE DATABASE SCHEMA (SIMPLIFIED)
-- PART 4: ROW LEVEL SECURITY (RLS) POLICIES & PERMISSIONS
-- ==============================================================================
-- Notice:
--  - Strictly preserves authorization boundaries for all remaining 10 tables:
--      1. Public read ONLY for published student-facing content
--      2. Private insert for student feedback
--      3. Admin-only isolation for administrative and audit tables
--  - Zero dead RLS policies for eliminated telemetry/notification tables.
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. SEMESTERS
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 2. SUBJECTS
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 3. FLASHCARD_UNITS
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 4. FLASHCARD_TOPICS
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 5. CONTENT_ITEMS
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 6. ADMIN_MEMBERS
-- ------------------------------------------------------------------------------
ALTER TABLE public.admin_members ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_members FROM anon, authenticated;
GRANT SELECT ON TABLE public.admin_members TO authenticated;

DROP POLICY IF EXISTS "admins can read admin membership" ON public.admin_members;
CREATE POLICY "admins can read admin membership"
  ON public.admin_members FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

-- ------------------------------------------------------------------------------
-- 7. ADMIN_ACTIVITY (Audit logging)
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 8. FEEDBACK_SUBMISSIONS
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 9. TESTIMONIALS
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 10. ADMIN_EMAIL_LOGS
-- ------------------------------------------------------------------------------
ALTER TABLE public.admin_email_logs ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_email_logs FROM anon, authenticated;
GRANT SELECT ON TABLE public.admin_email_logs TO authenticated;

DROP POLICY IF EXISTS "Admins can view email logs" ON public.admin_email_logs;
CREATE POLICY "Admins can view email logs"
  ON public.admin_email_logs FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));
