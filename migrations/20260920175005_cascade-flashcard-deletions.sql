-- Deleting a topic removes every flashcard assigned to that topic.
-- Deleting a unit removes its topics and every flashcard assigned to the unit.
-- Other content types cannot carry these hierarchy IDs because of
-- content_items_flashcard_hierarchy_check.
ALTER TABLE public.content_items
  DROP CONSTRAINT content_items_flashcard_topic_scope_fkey,
  DROP CONSTRAINT content_items_flashcard_unit_subject_fkey;

ALTER TABLE public.content_items
  ADD CONSTRAINT content_items_flashcard_unit_subject_fkey
    FOREIGN KEY (flashcard_unit_id, subject_id)
    REFERENCES public.flashcard_units(id, subject_id)
    ON DELETE CASCADE,
  ADD CONSTRAINT content_items_flashcard_topic_scope_fkey
    FOREIGN KEY (flashcard_topic_id, flashcard_unit_id, subject_id)
    REFERENCES public.flashcard_topics(id, unit_id, subject_id)
    ON DELETE CASCADE;
