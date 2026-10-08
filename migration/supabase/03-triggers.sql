-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 2 — SUPABASE DATABASE SCHEMA (SIMPLIFIED)
-- PART 3: TRIGGERS & TRIGGER FUNCTIONS
-- ==============================================================================
-- Architectural Simplification:
--  - Eliminated notification trigger routines (notification panel removed from UI).
--  - Eliminated background study tracking timestamp triggers.
--  - RETAINED:
--      1. Automatic updated_at timestamps on all 8 mutable application tables
--      2. trg_sync_admin_member_user_id (links admin accounts on auth changes)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. UPDATED_AT TRIGGERS (8 Mutable Tables)
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 2. AUTH.USERS -> ADMIN_MEMBERS SYNCHRONIZATION TRIGGER
-- ------------------------------------------------------------------------------
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
