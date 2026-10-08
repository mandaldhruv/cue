-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 3 — POST-DATA MIGRATION VERIFICATION SCRIPT
-- UNIFIED SINGLE QUERY (Displays all checks in one unified table in Supabase)
-- STRICTLY READ-ONLY: ZERO INSERT, UPDATE, DELETE, TRUNCATE, DROP, OR ALTER
-- ==============================================================================

SELECT 
  'A. Row Counts' AS section,
  'A1. semesters' AS check_name,
  count(*)::text AS actual_value,
  '6' AS expected_value,
  CASE WHEN count(*) = 6 THEN 'PASS' ELSE 'FAIL' END AS status
FROM public.semesters

UNION ALL SELECT 'A. Row Counts', 'A2. subjects', count(*)::text, '6',
  CASE WHEN count(*) = 6 THEN 'PASS' ELSE 'FAIL' END FROM public.subjects

UNION ALL SELECT 'A. Row Counts', 'A3. flashcard_units', count(*)::text, '16',
  CASE WHEN count(*) = 16 THEN 'PASS' ELSE 'FAIL' END FROM public.flashcard_units

UNION ALL SELECT 'A. Row Counts', 'A4. flashcard_topics', count(*)::text, '108',
  CASE WHEN count(*) = 108 THEN 'PASS' ELSE 'FAIL' END FROM public.flashcard_topics

UNION ALL SELECT 'A. Row Counts', 'A5. content_items', count(*)::text, '698',
  CASE WHEN count(*) = 698 THEN 'PASS' ELSE 'FAIL' END FROM public.content_items

UNION ALL SELECT 'A. Row Counts', 'A6. admin_members', count(*)::text, '3',
  CASE WHEN count(*) = 3 THEN 'PASS' ELSE 'FAIL' END FROM public.admin_members

UNION ALL SELECT 'A. Row Counts', 'A7. admin_activity', count(*)::text, '202',
  CASE WHEN count(*) = 202 THEN 'PASS' ELSE 'FAIL' END FROM public.admin_activity

UNION ALL SELECT 'A. Row Counts', 'A8. feedback_submissions', count(*)::text, '1',
  CASE WHEN count(*) = 1 THEN 'PASS' ELSE 'FAIL' END FROM public.feedback_submissions

UNION ALL SELECT 'A. Row Counts', 'A9. testimonials', count(*)::text, '2',
  CASE WHEN count(*) = 2 THEN 'PASS' ELSE 'FAIL' END FROM public.testimonials

UNION ALL SELECT 'A. Row Counts', 'A10. admin_email_logs', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END FROM public.admin_email_logs

UNION ALL SELECT 'A. Row Counts', 'A11. auth.users', count(*)::text, '16',
  CASE WHEN count(*) = 16 THEN 'PASS' ELSE 'FAIL' END FROM auth.users

UNION ALL SELECT 'A. Row Counts', 'A12. auth.identities', count(*)::text, '16',
  CASE WHEN count(*) = 16 THEN 'PASS' ELSE 'FAIL' END FROM auth.identities

-- B. UUID PRESERVATION
UNION ALL SELECT 'B. UUID Preservation', 'B. Key Admins in auth.users', count(*)::text, '3',
  CASE WHEN count(*) = 3 THEN 'PASS' ELSE 'FAIL' END
FROM auth.users
WHERE id IN (
  '7ea44757-9823-4010-93dc-90b7208b856b',
  '3b0e9715-b1d6-442f-84d4-4458f2a4daf8',
  'dff79aec-37bb-4b48-b7ab-daecd022f83b'
)

-- C. FOREIGN KEY INTEGRITY & ORPHANS
UNION ALL SELECT 'C. Foreign Keys', 'C1. Orphan flashcard_units', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM public.flashcard_units u
LEFT JOIN public.subjects s ON s.id = u.subject_id
WHERE s.id IS NULL

UNION ALL SELECT 'C. Foreign Keys', 'C2. Orphan flashcard_topics', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM public.flashcard_topics t
LEFT JOIN public.flashcard_units u ON u.id = t.unit_id
WHERE u.id IS NULL

UNION ALL SELECT 'C. Foreign Keys', 'C3. Orphan content_items (subjects)', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM public.content_items ci
LEFT JOIN public.subjects s ON s.id = ci.subject_id
WHERE s.id IS NULL

UNION ALL SELECT 'C. Foreign Keys', 'C4. Orphan content_items (units)', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM public.content_items ci
LEFT JOIN public.flashcard_units u ON u.id = ci.flashcard_unit_id
WHERE ci.flashcard_unit_id IS NOT NULL AND u.id IS NULL

UNION ALL SELECT 'C. Foreign Keys', 'C5. Orphan content_items (topics)', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM public.content_items ci
LEFT JOIN public.flashcard_topics t ON t.id = ci.flashcard_topic_id
WHERE ci.flashcard_topic_id IS NOT NULL AND t.id IS NULL

UNION ALL SELECT 'C. Foreign Keys', 'C6. Orphan admin_activity (user_id)', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM public.admin_activity aa
LEFT JOIN auth.users u ON u.id = aa.admin_user_id
WHERE u.id IS NULL

UNION ALL SELECT 'C. Foreign Keys', 'C7. Orphan admin_members (user_id)', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM public.admin_members am
LEFT JOIN auth.users u ON u.id = am.user_id
WHERE am.user_id IS NOT NULL AND u.id IS NULL

-- E. GENERATED NORMALIZED_TITLE
UNION ALL SELECT 'E. Generated Columns', 'E1. Unit normalized_title populated', count(*)::text, '16',
  CASE WHEN count(*) = 16 THEN 'PASS' ELSE 'FAIL' END
FROM public.flashcard_units
WHERE normalized_title IS NOT NULL AND length(normalized_title) > 0

UNION ALL SELECT 'E. Generated Columns', 'E2. Topic normalized_title populated', count(*)::text, '108',
  CASE WHEN count(*) = 108 THEN 'PASS' ELSE 'FAIL' END
FROM public.flashcard_topics
WHERE normalized_title IS NOT NULL AND length(normalized_title) > 0

-- F. HISTORICAL TIMESTAMPS
UNION ALL SELECT 'F. Timestamps', 'F. Historical Timestamps Preserved', count(*)::text, '698',
  CASE WHEN count(*) = 698 THEN 'PASS' ELSE 'FAIL' END
FROM public.content_items
WHERE created_at < now() - interval '1 hour'

-- G. ADMIN WHITELIST
UNION ALL SELECT 'G. Admin Accounts', 'G. Authorized Admin Accounts Whitelist', count(*)::text, '3',
  CASE WHEN count(*) = 3 THEN 'PASS' ELSE 'FAIL' END
FROM public.admin_members
WHERE lower(email) IN (
  'hersita04@gmail.com',
  'harshita301doc@gmail.com',
  'harsyng14@gmail.com'
) AND is_active = true

-- H. GOOGLE IDENTITIES
UNION ALL SELECT 'H. Google OAuth', 'H. Google OAuth Identities Mapped', count(*)::text, '16',
  CASE WHEN count(*) = 16 THEN 'PASS' ELSE 'FAIL' END
FROM auth.identities
WHERE provider = 'google'

-- I. EXCLUDED LEGACY TABLES
UNION ALL SELECT 'I. Excluded Legacy', 'I. Legacy Telemetry Absence', count(*)::text, '0',
  CASE WHEN count(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM information_schema.tables
WHERE table_schema = 'public'
  AND (
    table_name LIKE '%study%'
    OR table_name LIKE '%greeting%'
    OR table_name LIKE '%notification%'
  )
ORDER BY check_name;
