CREATE TABLE public.admin_members (
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

CREATE UNIQUE INDEX admin_members_user_id_unique
  ON public.admin_members (user_id) WHERE user_id IS NOT NULL;

CREATE TRIGGER admin_members_set_updated_at
  BEFORE UPDATE ON public.admin_members
  FOR EACH ROW EXECUTE FUNCTION system.update_updated_at();

CREATE OR REPLACE FUNCTION public.is_cue_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.admin_members AS member
    JOIN auth.users AS account
      ON account.id = (SELECT auth.uid())
     AND lower(account.email) = lower(member.email)
    WHERE member.is_active = true
      AND (member.user_id IS NULL OR member.user_id = account.id)
  );
$$;

REVOKE ALL ON FUNCTION public.is_cue_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_cue_admin() TO authenticated;

ALTER TABLE public.admin_members ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_members FROM anon, authenticated;
GRANT SELECT ON TABLE public.admin_members TO authenticated;

CREATE POLICY "admins can read admin membership"
  ON public.admin_members FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

INSERT INTO public.admin_members (email, display_name, role)
VALUES ('hersita04@gmail.com', 'Harshita Singh', 'owner');

GRANT INSERT, UPDATE, DELETE ON TABLE public.semesters, public.subjects, public.content_items TO authenticated;

CREATE POLICY "admins can create semesters"
  ON public.semesters FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can update semesters"
  ON public.semesters FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can delete semesters"
  ON public.semesters FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

CREATE POLICY "admins can create subjects"
  ON public.subjects FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can update subjects"
  ON public.subjects FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can delete subjects"
  ON public.subjects FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

CREATE POLICY "admins can create content"
  ON public.content_items FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can update content"
  ON public.content_items FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can delete content"
  ON public.content_items FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

CREATE TABLE public.admin_activity (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE RESTRICT,
  action text NOT NULL,
  entity_type text NOT NULL,
  entity_id uuid,
  summary text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX admin_activity_created_idx ON public.admin_activity (created_at DESC);
ALTER TABLE public.admin_activity ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.admin_activity FROM anon, authenticated;
GRANT SELECT, INSERT ON TABLE public.admin_activity TO authenticated;

CREATE POLICY "admins can read activity"
  ON public.admin_activity FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can record activity"
  ON public.admin_activity FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()) AND admin_user_id = (SELECT auth.uid()));
