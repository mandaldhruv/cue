CREATE TABLE public.flashcard_units (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id uuid NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  title text NOT NULL CHECK (char_length(btrim(title)) BETWEEN 1 AND 120),
  normalized_title text GENERATED ALWAYS AS (
    lower(regexp_replace(btrim(title), '\s+', ' ', 'g'))
  ) STORED,
  sort_order integer NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
  is_published boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (subject_id, normalized_title),
  UNIQUE (id, subject_id)
);

CREATE TABLE public.flashcard_topics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id uuid NOT NULL,
  unit_id uuid NOT NULL,
  title text NOT NULL CHECK (char_length(btrim(title)) BETWEEN 1 AND 140),
  normalized_title text GENERATED ALWAYS AS (
    lower(regexp_replace(btrim(title), '\s+', ' ', 'g'))
  ) STORED,
  sort_order integer NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
  is_published boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT flashcard_topics_unit_subject_fkey
    FOREIGN KEY (unit_id, subject_id)
    REFERENCES public.flashcard_units(id, subject_id)
    ON DELETE CASCADE,
  UNIQUE (unit_id, normalized_title),
  UNIQUE (id, unit_id, subject_id)
);

ALTER TABLE public.content_items
  ADD COLUMN flashcard_unit_id uuid,
  ADD COLUMN flashcard_topic_id uuid,
  ADD COLUMN question_document jsonb,
  ADD COLUMN answer_document jsonb,
  ADD CONSTRAINT content_items_flashcard_unit_subject_fkey
    FOREIGN KEY (flashcard_unit_id, subject_id)
    REFERENCES public.flashcard_units(id, subject_id)
    ON DELETE SET NULL (flashcard_unit_id),
  ADD CONSTRAINT content_items_flashcard_topic_scope_fkey
    FOREIGN KEY (flashcard_topic_id, flashcard_unit_id, subject_id)
    REFERENCES public.flashcard_topics(id, unit_id, subject_id)
    ON DELETE SET NULL (flashcard_topic_id),
  ADD CONSTRAINT content_items_flashcard_hierarchy_check CHECK (
    content_type = 'flashcard'
    OR (flashcard_unit_id IS NULL AND flashcard_topic_id IS NULL
        AND question_document IS NULL AND answer_document IS NULL)
  );

CREATE INDEX flashcard_units_subject_sort_idx
  ON public.flashcard_units (subject_id, sort_order, title);
CREATE INDEX flashcard_topics_unit_sort_idx
  ON public.flashcard_topics (unit_id, sort_order, title);
CREATE INDEX content_items_flashcard_hierarchy_idx
  ON public.content_items (subject_id, flashcard_unit_id, flashcard_topic_id, sort_order)
  WHERE content_type = 'flashcard';

CREATE TRIGGER flashcard_units_set_updated_at
  BEFORE UPDATE ON public.flashcard_units
  FOR EACH ROW EXECUTE FUNCTION system.update_updated_at();
CREATE TRIGGER flashcard_topics_set_updated_at
  BEFORE UPDATE ON public.flashcard_topics
  FOR EACH ROW EXECUTE FUNCTION system.update_updated_at();

ALTER TABLE public.flashcard_units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.flashcard_topics ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.flashcard_units, public.flashcard_topics FROM anon, authenticated;
GRANT SELECT ON TABLE public.flashcard_units, public.flashcard_topics TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON TABLE public.flashcard_units, public.flashcard_topics TO authenticated;

CREATE POLICY "published flashcard units are publicly readable"
  ON public.flashcard_units FOR SELECT TO anon, authenticated
  USING (is_published = true);
CREATE POLICY "published flashcard topics are publicly readable"
  ON public.flashcard_topics FOR SELECT TO anon, authenticated
  USING (is_published = true);

CREATE POLICY "admins can read all flashcard units"
  ON public.flashcard_units FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can create flashcard units"
  ON public.flashcard_units FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can update flashcard units"
  ON public.flashcard_units FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can delete flashcard units"
  ON public.flashcard_units FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

CREATE POLICY "admins can read all flashcard topics"
  ON public.flashcard_topics FOR SELECT TO authenticated
  USING ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can create flashcard topics"
  ON public.flashcard_topics FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can update flashcard topics"
  ON public.flashcard_topics FOR UPDATE TO authenticated
  USING ((SELECT public.is_cue_admin()))
  WITH CHECK ((SELECT public.is_cue_admin()));
CREATE POLICY "admins can delete flashcard topics"
  ON public.flashcard_topics FOR DELETE TO authenticated
  USING ((SELECT public.is_cue_admin()));

CREATE OR REPLACE FUNCTION public.is_published_cue_flashcard_media(object_key text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.content_items
    WHERE content_type = 'flashcard'
      AND is_published = true
      AND (
        position(to_jsonb(object_key)::text in coalesce(question_document::text, '')) > 0
        OR position(to_jsonb(object_key)::text in coalesce(answer_document::text, '')) > 0
      )
  );
$$;

REVOKE ALL ON FUNCTION public.is_published_cue_flashcard_media(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_published_cue_flashcard_media(text) TO anon, authenticated;

CREATE POLICY cue_flashcards_published_read
  ON storage.objects FOR SELECT TO anon, authenticated
  USING (
    bucket = 'cue-flashcards'
    AND (SELECT public.is_published_cue_flashcard_media(key))
  );
CREATE POLICY cue_flashcards_admin_read
  ON storage.objects FOR SELECT TO authenticated
  USING (bucket = 'cue-flashcards' AND (SELECT public.is_cue_admin()));
CREATE POLICY cue_flashcards_admin_insert
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket = 'cue-flashcards'
    AND uploaded_by = (SELECT auth.jwt() ->> 'sub')
    AND (SELECT public.is_cue_admin())
  );
CREATE POLICY cue_flashcards_admin_update
  ON storage.objects FOR UPDATE TO authenticated
  USING (bucket = 'cue-flashcards' AND (SELECT public.is_cue_admin()))
  WITH CHECK (bucket = 'cue-flashcards' AND (SELECT public.is_cue_admin()));
CREATE POLICY cue_flashcards_admin_delete
  ON storage.objects FOR DELETE TO authenticated
  USING (bucket = 'cue-flashcards' AND (SELECT public.is_cue_admin()));
