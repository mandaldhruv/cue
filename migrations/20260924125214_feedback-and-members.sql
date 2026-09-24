-- Migration: feedback-and-members
-- Add fields for authenticated user feedback and publish status

ALTER TABLE public.feedback_submissions 
  ADD COLUMN IF NOT EXISTS user_id uuid,
  ADD COLUMN IF NOT EXISTS user_name text,
  ADD COLUMN IF NOT EXISTS role text,
  ADD COLUMN IF NOT EXISTS is_published boolean DEFAULT false;

ALTER TABLE public.testimonials
  ADD COLUMN IF NOT EXISTS feedback_id uuid;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'testimonials_feedback_id_key'
  ) THEN
    ALTER TABLE public.testimonials ADD CONSTRAINT testimonials_feedback_id_key UNIQUE (feedback_id);
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS feedback_submissions_user_id_idx ON public.feedback_submissions(user_id);
CREATE INDEX IF NOT EXISTS feedback_submissions_is_published_idx ON public.feedback_submissions(is_published);
CREATE INDEX IF NOT EXISTS testimonials_feedback_id_idx ON public.testimonials(feedback_id);

-- Secure RPC function to fetch registered users / members for authorized Cue admins only
CREATE OR REPLACE FUNCTION public.get_cue_members()
RETURNS TABLE (
  id uuid,
  email text,
  name text,
  role text,
  email_verified boolean,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  last_seen timestamp with time zone
)
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  RETURN QUERY
  SELECT 
    u.id,
    u.email,
    COALESCE(NULLIF(trim(u.profile->>'name'), ''), split_part(u.email, '@', 1)) AS name,
    CASE 
      WHEN am.role IS NOT NULL THEN 'Admin (' || am.role || ')'
      WHEN u.is_project_admin = true THEN 'Admin'
      ELSE 'Student'
    END AS role,
    COALESCE(u.email_verified, false) AS email_verified,
    u.created_at,
    u.updated_at,
    g.last_seen
  FROM auth.users u
  LEFT JOIN public.admin_members am ON lower(am.email) = lower(u.email) AND am.is_active = true
  LEFT JOIN (
    SELECT user_id, max(created_at) AS last_seen 
    FROM public.greeting_display_events 
    GROUP BY user_id
  ) g ON g.user_id = u.id
  ORDER BY u.created_at DESC;
END;
$$;
