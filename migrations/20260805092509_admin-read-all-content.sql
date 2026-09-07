CREATE POLICY "admins can read all semesters"
  ON public.semesters FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

CREATE POLICY "admins can read all subjects"
  ON public.subjects FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));

CREATE POLICY "admins can read all content"
  ON public.content_items FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));
