-- Admin Email Notifications Log & Deduplication
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

ALTER TABLE public.admin_email_logs ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_email_logs FROM anon, authenticated;
GRANT SELECT ON TABLE public.admin_email_logs TO authenticated;

DROP POLICY IF EXISTS "Admins can view email logs" ON public.admin_email_logs;
CREATE POLICY "Admins can view email logs"
ON public.admin_email_logs FOR SELECT TO authenticated
USING ((SELECT public.is_cue_admin()));
