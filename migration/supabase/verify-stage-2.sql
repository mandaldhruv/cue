-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 2B — POST-EXECUTION VERIFICATION SCRIPT
-- RUN THIS IN SUPABASE SQL EDITOR TO VERIFY SCHEMA DEPLOYMENT
-- ==============================================================================

SELECT '1. APPLICATION TABLES (Expected: 10)' AS check_category,
       count(*)::text AS actual_count,
       CASE WHEN count(*) = 10 THEN 'PASS' ELSE 'FAIL' END AS status,
       string_agg(table_name, ', ' ORDER BY table_name) AS details
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE';

SELECT '2. CONFIRM ABSENCE OF REMOVED TELEMETRY TABLES (Expected: 0)' AS check_category,
       count(*)::text AS actual_count,
       CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status,
       COALESCE(string_agg(table_name, ', '), 'None found (clean)') AS details
FROM information_schema.tables
WHERE table_schema = 'public'
  AND (
    table_name LIKE '%study%'
    OR table_name LIKE '%greeting%'
    OR table_name LIKE '%notification%'
  );

SELECT '3. RETAINED FUNCTIONS (Expected: 7)' AS check_category,
       count(*)::text AS actual_count,
       CASE WHEN count(*) = 7 THEN 'PASS' ELSE 'FAIL' END AS status,
       string_agg(routine_name, ', ' ORDER BY routine_name) AS details
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name IN (
    'set_updated_at',
    'is_cue_admin',
    'get_cue_members',
    'sync_admin_member_user_id',
    'is_published_cue_pyq',
    'is_published_cue_testimonial',
    'is_published_cue_flashcard_media'
  );

SELECT '4. RETAINED TRIGGERS (Expected: 9)' AS check_category,
       count(*)::text AS actual_count,
       CASE WHEN count(*) = 9 THEN 'PASS' ELSE 'FAIL' END AS status,
       string_agg(trigger_name, ', ' ORDER BY trigger_name) AS details
FROM information_schema.triggers
WHERE trigger_schema IN ('public', 'auth')
  AND trigger_name IN (
    'semesters_set_updated_at',
    'subjects_set_updated_at',
    'flashcard_units_set_updated_at',
    'flashcard_topics_set_updated_at',
    'content_items_set_updated_at',
    'admin_members_set_updated_at',
    'feedback_submissions_set_updated_at',
    'testimonials_set_updated_at',
    'trg_sync_admin_member_user_id'
  );

SELECT '5. RLS STATUS ON 10 CORE TABLES (Expected: 10 enabled)' AS check_category,
       count(*)::text AS actual_count,
       CASE WHEN count(*) = 10 THEN 'PASS' ELSE 'FAIL' END AS status,
       string_agg(relname, ', ' ORDER BY relname) AS details
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND c.relkind = 'r'
  AND c.relrowsecurity = true
  AND c.relname IN (
    'semesters',
    'subjects',
    'flashcard_units',
    'flashcard_topics',
    'content_items',
    'admin_members',
    'admin_activity',
    'feedback_submissions',
    'testimonials',
    'admin_email_logs'
  );

SELECT '6. STORAGE BUCKETS (Expected: 3)' AS check_category,
       count(*)::text AS actual_count,
       CASE WHEN count(*) = 3 THEN 'PASS' ELSE 'FAIL' END AS status,
       string_agg(id, ', ' ORDER BY id) AS details
FROM storage.buckets
WHERE id IN ('cue-pyqs', 'cue-testimonials', 'cue-flashcards');
