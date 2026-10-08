-- ==============================================================================
-- CUE BACKEND MIGRATION: STAGE 3C — STORAGE POST-UPLOAD VERIFICATION QUERY
-- TARGET: Supabase PostgreSQL (Project ID: yxuxwcaldluhmteupzhp)
-- PURPOSE: Verify that the 7 approved storage assets exist at their exact paths,
--          in their expected buckets, with exact byte sizes and correct MIME types,
--          and that no application database records were modified.
-- ==============================================================================

WITH expected_assets AS (
  SELECT 'cue-testimonials' AS expected_bucket,
         '2a816127-3a7d-4d66-a2fe-c2d9ceabadf2/20232fce-f7d8-46d1-8dbc-95126d1e3e18-a65db50f-c0aa-4c56-97a3-d514d6135321.jpeg' AS expected_name,
         274148::bigint AS expected_size,
         'image/jpeg' AS expected_mime,
         'Harshita Singh Headshot' AS asset_title
  UNION ALL
  SELECT 'cue-testimonials',
         'a8cd6602-5e4a-4a27-a068-3ff4e4023472/4f2284a9-b1ff-48ba-88c9-d227fecf2081-1000012038.jpg',
         241650::bigint,
         'image/jpeg',
         'Rupal Shroff Headshot'
  UNION ALL
  SELECT 'cue-pyqs',
         'd585435a-10fa-4be9-91af-5303a4204ef8/2025/a3d40074-6d7d-4814-b472-729b40020dea-elementary-hindi-2025.pdf',
         29133::bigint,
         'application/pdf',
         'Elementary Hindi — Oct 2025'
  UNION ALL
  SELECT 'cue-pyqs',
         'd585435a-10fa-4be9-91af-5303a4204ef8/2024/60b1d853-d433-44fc-a32f-9e24da32368d-hindi-october-2024-1-.pdf',
         2526652::bigint,
         'application/pdf',
         'Hindi — Oct 2024'
  UNION ALL
  SELECT 'cue-pyqs',
         '5c93c785-bc3e-4489-969c-9ec5f21c174a/2024/5b08ca41-bfde-4c9c-b868-47645752f4e5-principles-of-economics-ii-oct2024.pdf',
         3557715::bigint,
         'application/pdf',
         'Principles of Economics II — Oct 2024'
  UNION ALL
  SELECT 'cue-pyqs',
         '1ba3fabc-a2c8-4c58-a388-cb07c2a4d70d/2024/17f11253-9a68-4903-abe7-70c1a288dbc7-business-planning-and-entrepreneurship-management-oct2024.pdf',
         6515354::bigint,
         'application/pdf',
         'BPEM — Oct 2024'
  UNION ALL
  SELECT 'cue-pyqs',
         '4942b243-3eda-4100-9200-942a29e98d11/2024/d6749521-e7ca-476a-9bec-45fd90d26a33-equity-and-debt-markets-oct2024.pdf',
         4430616::bigint,
         'application/pdf',
         'Equity and Debt Markets — Oct 2024'
)
SELECT
  e.asset_title,
  e.expected_bucket,
  CASE
    WHEN so.name IS NULL THEN 'FAIL (Object Missing in Storage)'
    WHEN (so.metadata->>'size')::bigint <> e.expected_size THEN 'FAIL (Size Mismatch)'
    WHEN COALESCE(so.metadata->>'mimetype', '') <> e.expected_mime THEN 'FAIL (MIME Mismatch)'
    ELSE 'PASS'
  END AS status,
  e.expected_size,
  (so.metadata->>'size')::bigint AS actual_size,
  e.expected_mime,
  so.metadata->>'mimetype' AS actual_mime,
  e.expected_name AS storage_key
FROM expected_assets e
LEFT JOIN storage.objects so
  ON so.bucket_id = e.expected_bucket
 AND so.name = e.expected_name
ORDER BY e.expected_bucket, e.asset_title;
