-- Admin Notification System Migration
-- Creates admin_notifications table, indexes, RLS policies, RPC functions, and triggers

-- 1. Create admin_notifications table
CREATE TABLE IF NOT EXISTS public.admin_notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text NOT NULL, -- 'new_member', 'new_feedback', 'content_issue', 'testimonial_published', 'pyq_updated', 'content_updated'
  title text NOT NULL,
  message text NOT NULL,
  category text NOT NULL, -- 'members', 'feedback', 'pyqs', 'content'
  priority text NOT NULL DEFAULT 'normal', -- 'normal', 'high'
  link text NOT NULL DEFAULT '/admin',
  related_id uuid,
  is_read boolean NOT NULL DEFAULT false,
  read_at timestamptz,
  read_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Deduplication index preventing duplicate notifications for same event/record
CREATE UNIQUE INDEX IF NOT EXISTS admin_notifications_dedup_idx 
ON public.admin_notifications (type, related_id) 
WHERE related_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS admin_notifications_read_created_idx 
ON public.admin_notifications (is_read, created_at DESC);

CREATE INDEX IF NOT EXISTS admin_notifications_category_read_idx 
ON public.admin_notifications (category, is_read);

-- 2. Row Level Security
ALTER TABLE public.admin_notifications ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_notifications FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.admin_notifications TO authenticated;

DROP POLICY IF EXISTS "Admins can select notifications" ON public.admin_notifications;
CREATE POLICY "Admins can select notifications"
ON public.admin_notifications FOR SELECT TO authenticated
USING ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "Admins can insert notifications" ON public.admin_notifications;
CREATE POLICY "Admins can insert notifications"
ON public.admin_notifications FOR INSERT TO authenticated
WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "Admins can update notifications" ON public.admin_notifications;
CREATE POLICY "Admins can update notifications"
ON public.admin_notifications FOR UPDATE TO authenticated
USING ((SELECT public.is_cue_admin()))
WITH CHECK ((SELECT public.is_cue_admin()));

DROP POLICY IF EXISTS "Admins can delete notifications" ON public.admin_notifications;
CREATE POLICY "Admins can delete notifications"
ON public.admin_notifications FOR DELETE TO authenticated
USING ((SELECT public.is_cue_admin()));

-- 3. Notification helper function for inserting/updating notifications
CREATE OR REPLACE FUNCTION public.record_admin_notification(
  p_type text,
  p_title text,
  p_message text,
  p_category text,
  p_priority text DEFAULT 'normal',
  p_link text DEFAULT '/admin',
  p_related_id uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_id uuid;
BEGIN
  IF p_related_id IS NOT NULL THEN
    INSERT INTO public.admin_notifications (
      type, title, message, category, priority, link, related_id, is_read, read_at, read_by, created_at
    )
    VALUES (
      p_type, p_title, p_message, p_category, p_priority, p_link, p_related_id, false, NULL, NULL, now()
    )
    ON CONFLICT (type, related_id) WHERE related_id IS NOT NULL
    DO UPDATE SET
      title = EXCLUDED.title,
      message = EXCLUDED.message,
      category = EXCLUDED.category,
      priority = EXCLUDED.priority,
      link = EXCLUDED.link,
      is_read = false,
      read_at = NULL,
      read_by = NULL,
      created_at = now()
    RETURNING id INTO v_id;
  ELSE
    INSERT INTO public.admin_notifications (
      type, title, message, category, priority, link, related_id, is_read, created_at
    )
    VALUES (
      p_type, p_title, p_message, p_category, p_priority, p_link, NULL, false, now()
    )
    RETURNING id INTO v_id;
  END IF;

  RETURN v_id;
END;
$$;

REVOKE ALL ON FUNCTION public.record_admin_notification FROM anon, public;
GRANT EXECUTE ON FUNCTION public.record_admin_notification TO authenticated;

-- 4. Notification count function
CREATE OR REPLACE FUNCTION public.get_admin_notification_counts()
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_total int := 0;
  v_members int := 0;
  v_feedback int := 0;
  v_content int := 0;
  v_pyqs int := 0;
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  SELECT count(*) INTO v_total
  FROM public.admin_notifications
  WHERE is_read = false;

  SELECT count(*) INTO v_members
  FROM public.admin_notifications
  WHERE is_read = false AND category = 'members';

  SELECT count(*) INTO v_feedback
  FROM public.admin_notifications
  WHERE is_read = false AND category = 'feedback';

  SELECT count(*) INTO v_content
  FROM public.admin_notifications
  WHERE is_read = false AND category = 'content';

  SELECT count(*) INTO v_pyqs
  FROM public.admin_notifications
  WHERE is_read = false AND category = 'pyqs';

  RETURN json_build_object(
    'total', v_total,
    'members', v_members,
    'feedback', v_feedback,
    'content', v_content,
    'pyqs', v_pyqs
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_admin_notification_counts FROM anon, public;
GRANT EXECUTE ON FUNCTION public.get_admin_notification_counts TO authenticated;

-- 5. List notifications function
CREATE OR REPLACE FUNCTION public.get_admin_notifications(
  p_limit int DEFAULT 50,
  p_category text DEFAULT NULL
)
RETURNS TABLE (
  id uuid,
  type text,
  title text,
  message text,
  category text,
  priority text,
  link text,
  related_id uuid,
  is_read boolean,
  read_at timestamptz,
  created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  RETURN QUERY
  SELECT
    n.id,
    n.type,
    n.title,
    n.message,
    n.category,
    n.priority,
    n.link,
    n.related_id,
    n.is_read,
    n.read_at,
    n.created_at
  FROM public.admin_notifications n
  WHERE (p_category IS NULL OR n.category = p_category)
  ORDER BY n.created_at DESC
  LIMIT coalesce(p_limit, 50);
END;
$$;

REVOKE ALL ON FUNCTION public.get_admin_notifications FROM anon, public;
GRANT EXECUTE ON FUNCTION public.get_admin_notifications TO authenticated;

-- 6. Mark single notification read
CREATE OR REPLACE FUNCTION public.mark_admin_notification_read(p_id uuid)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  UPDATE public.admin_notifications
  SET
    is_read = true,
    read_at = now(),
    read_by = auth.uid()
  WHERE id = p_id;

  RETURN true;
END;
$$;

REVOKE ALL ON FUNCTION public.mark_admin_notification_read FROM anon, public;
GRANT EXECUTE ON FUNCTION public.mark_admin_notification_read TO authenticated;

-- 7. Mark all notifications read
CREATE OR REPLACE FUNCTION public.mark_all_admin_notifications_read()
RETURNS int
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_updated int := 0;
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  WITH updated AS (
    UPDATE public.admin_notifications
    SET
      is_read = true,
      read_at = now(),
      read_by = auth.uid()
    WHERE is_read = false
    RETURNING 1
  )
  SELECT count(*) INTO v_updated FROM updated;

  RETURN v_updated;
END;
$$;

REVOKE ALL ON FUNCTION public.mark_all_admin_notifications_read FROM anon, public;
GRANT EXECUTE ON FUNCTION public.mark_all_admin_notifications_read TO authenticated;

-- 8. Mark category notifications read
CREATE OR REPLACE FUNCTION public.mark_category_admin_notifications_read(p_category text)
RETURNS int
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_updated int := 0;
BEGIN
  IF NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin authorization required';
  END IF;

  WITH updated AS (
    UPDATE public.admin_notifications
    SET
      is_read = true,
      read_at = now(),
      read_by = auth.uid()
    WHERE is_read = false AND category = p_category
    RETURNING 1
  )
  SELECT count(*) INTO v_updated FROM updated;

  RETURN v_updated;
END;
$$;

REVOKE ALL ON FUNCTION public.mark_category_admin_notifications_read FROM anon, public;
GRANT EXECUTE ON FUNCTION public.mark_category_admin_notifications_read TO authenticated;

-- 9. Trigger on auth.users for new member registration
CREATE OR REPLACE FUNCTION public.notify_on_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_name text;
  v_email text;
BEGIN
  v_email := lower(coalesce(NEW.email, ''));
  
  -- Skip admin accounts from generating "New member" notifications
  IF v_email IN ('hersita04@gmail.com', 'harshita301doc@gmail.com') THEN
    RETURN NEW;
  END IF;

  -- Only notify if user is verified
  IF NEW.email_verified IS NOT TRUE THEN
    RETURN NEW;
  END IF;

  v_name := coalesce(nullif(trim(NEW.profile->>'name'), ''), split_part(v_email, '@', 1));
  IF v_name IS NULL OR v_name = '' THEN
    v_name := 'A new student';
  END IF;

  PERFORM public.record_admin_notification(
    'new_member',
    'New member',
    v_name || ' joined as a Student',
    'members',
    'normal',
    '/admin/members',
    NEW.id
  );

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_new_user ON auth.users;
CREATE TRIGGER trg_notify_new_user
AFTER INSERT OR UPDATE OF email_verified ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.notify_on_new_user();

-- 10. Trigger on feedback_submissions for new feedback and content issues
CREATE OR REPLACE FUNCTION public.notify_on_new_feedback()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_name text;
  v_role text;
BEGIN
  v_name := coalesce(nullif(trim(NEW.user_name), ''), split_part(coalesce(NEW.email, ''), '@', 1));
  IF v_name IS NULL OR v_name = '' THEN
    v_name := 'A user';
  END IF;

  IF NEW.is_content_issue IS TRUE THEN
    PERFORM public.record_admin_notification(
      'content_issue',
      'Content issue reported',
      v_name || ' reported an incorrect or outdated content issue',
      'feedback',
      'high',
      '/admin/feedback',
      NEW.id
    );
  ELSE
    v_role := coalesce(nullif(trim(NEW.student_year), ''), 'Student');
    PERFORM public.record_admin_notification(
      'new_feedback',
      'New feedback',
      v_name || ' submitted new feedback as a ' || v_role,
      'feedback',
      'normal',
      '/admin/feedback',
      NEW.id
    );
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_new_feedback ON public.feedback_submissions;
CREATE TRIGGER trg_notify_new_feedback
AFTER INSERT ON public.feedback_submissions
FOR EACH ROW
EXECUTE FUNCTION public.notify_on_new_feedback();

-- 11. Trigger on testimonials for published testimonials
CREATE OR REPLACE FUNCTION public.notify_on_testimonial_published()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_name text;
BEGIN
  IF NEW.is_published IS TRUE AND (TG_OP = 'INSERT' OR OLD.is_published IS NOT TRUE) THEN
    v_name := coalesce(nullif(trim(NEW.person_name), ''), 'Member');
    PERFORM public.record_admin_notification(
      'testimonial_published',
      'Testimonial published',
      'Feedback from ' || v_name || ' was published as a testimonial',
      'feedback',
      'normal',
      '/admin/feedback',
      NEW.id
    );
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_testimonial_published ON public.testimonials;
CREATE TRIGGER trg_notify_testimonial_published
AFTER INSERT OR UPDATE OF is_published ON public.testimonials
FOR EACH ROW
EXECUTE FUNCTION public.notify_on_testimonial_published();

-- 12. Seed existing members and feedback as already read
INSERT INTO public.admin_notifications (
  type, title, message, category, priority, link, related_id, is_read, read_at, created_at
)
SELECT
  'new_member',
  'New member',
  coalesce(nullif(trim(u.profile->>'name'), ''), split_part(u.email, '@', 1)) || ' joined as a Student',
  'members',
  'normal',
  '/admin/members',
  u.id,
  true,
  u.created_at,
  u.created_at
FROM auth.users u
WHERE lower(u.email) NOT IN ('hersita04@gmail.com', 'harshita301doc@gmail.com')
ON CONFLICT (type, related_id) WHERE related_id IS NOT NULL DO NOTHING;

INSERT INTO public.admin_notifications (
  type, title, message, category, priority, link, related_id, is_read, read_at, created_at
)
SELECT
  CASE WHEN fb.is_content_issue THEN 'content_issue' ELSE 'new_feedback' END,
  CASE WHEN fb.is_content_issue THEN 'Content issue reported' ELSE 'New feedback' END,
  CASE WHEN fb.is_content_issue
    THEN coalesce(nullif(trim(fb.user_name), ''), split_part(fb.email, '@', 1), 'A user') || ' reported an incorrect or outdated content issue'
    ELSE coalesce(nullif(trim(fb.user_name), ''), split_part(fb.email, '@', 1), 'A user') || ' submitted new feedback as a ' || coalesce(nullif(trim(fb.student_year), ''), 'Student')
  END,
  'feedback',
  CASE WHEN fb.is_content_issue THEN 'high' ELSE 'normal' END,
  '/admin/feedback',
  fb.id,
  true,
  fb.created_at,
  fb.created_at
FROM public.feedback_submissions fb
ON CONFLICT (type, related_id) WHERE related_id IS NOT NULL DO NOTHING;
