import { createInsForgeServerClient } from "./insforge/server";

export type PublicSubjectRecord = {
  id: string; name: string; slug: string; short_code: string; course_code: string;
  semester_number: number; description: string; accent_color: string; sort_order: number;
};

export type PublicContentRecord = {
  id: string; subject_id: string; content_type: "syllabus_unit" | "note" | "flashcard" | "pyq" | "important_topic" | "recommended_resource";
  title: string; description: string; body: string; academic_year: number | null;
  file_url: string | null; file_key: string | null; sort_order: number;
  flashcard_unit_id?: string | null; flashcard_topic_id?: string | null;
  question_document?: import("../flashcards/rich-content").RichDocument | null;
  answer_document?: import("../flashcards/rich-content").RichDocument | null;
};

export type PublicFlashcardUnit = { id: string; subject_id: string; title: string; sort_order: number };
export type PublicFlashcardTopic = { id: string; subject_id: string; unit_id: string; title: string; sort_order: number };

export async function getPublishedSubject(slug: string) {
  const client = await createInsForgeServerClient();
  const { data, error } = await client.database.from("subjects")
    .select("id,name,slug,short_code,course_code,semester_number,description,accent_color,sort_order")
    .eq("slug", slug).eq("is_published", true).limit(1);
  return { subject: error ? null : (data?.[0] as PublicSubjectRecord | undefined) ?? null, error };
}

export async function getPublishedSubjects() {
  const client = await createInsForgeServerClient();
  const { data, error } = await client.database.from("subjects")
    .select("id,name,slug,short_code,course_code,semester_number,description,accent_color,sort_order")
    .eq("course_code", "BMS").eq("is_published", true)
    .order("semester_number", { ascending: true }).order("sort_order", { ascending: true });
  return { subjects: error ? [] : (data ?? []) as PublicSubjectRecord[], error };
}

export async function getPublishedContent(subjectId?: string, contentType?: PublicContentRecord["content_type"]) {
  const client = await createInsForgeServerClient();
  let query = client.database.from("content_items")
    .select("id,subject_id,content_type,title,description,body,academic_year,file_url,file_key,sort_order")
    .eq("is_published", true).order("sort_order", { ascending: true });
  if (subjectId) query = query.eq("subject_id", subjectId);
  if (contentType) query = query.eq("content_type", contentType);
  const { data, error } = await query;
  return { content: error ? [] : (data ?? []) as PublicContentRecord[], error };
}

export async function getPublishedFlashcardDeck(subjectId: string) {
  const client = await createInsForgeServerClient();
  const [unitResult, topicResult, cardResult] = await Promise.all([
    client.database.from("flashcard_units").select("id,subject_id,title,sort_order").eq("subject_id", subjectId).eq("is_published", true).order("sort_order", { ascending: true }),
    client.database.from("flashcard_topics").select("id,subject_id,unit_id,title,sort_order").eq("subject_id", subjectId).eq("is_published", true).order("sort_order", { ascending: true }),
    client.database.from("content_items").select("id,subject_id,content_type,title,description,body,sort_order,flashcard_unit_id,flashcard_topic_id,question_document,answer_document").eq("subject_id", subjectId).eq("content_type", "flashcard").eq("is_published", true).order("sort_order", { ascending: true }),
  ]);
  const error = unitResult.error ?? topicResult.error ?? cardResult.error;
  const units = (unitResult.data ?? []) as PublicFlashcardUnit[];
  const topics = (topicResult.data ?? []) as PublicFlashcardTopic[];
  const unitIds = new Set(units.map((item) => item.id));
  const topicIds = new Set(topics.map((item) => item.id));
  const cards = ((cardResult.data ?? []) as PublicContentRecord[]).filter((card) =>
    (!card.flashcard_unit_id && !card.flashcard_topic_id)
    || (!!card.flashcard_unit_id && !!card.flashcard_topic_id && unitIds.has(card.flashcard_unit_id) && topicIds.has(card.flashcard_topic_id))
  );
  return {
    units,
    topics,
    cards,
    error,
  };
}
