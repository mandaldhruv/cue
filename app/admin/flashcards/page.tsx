import { redirect } from "next/navigation";
import { getAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { ContentRecord, FlashcardTopicRecord, FlashcardUnitRecord, SubjectRecord } from "../types";
import FlashcardManager from "./FlashcardManager";

export const dynamic = "force-dynamic";

export default async function AdminFlashcardsPage() {
  const { user, isAdmin, client } = await getAdminSession();
  if (!user || !isAdmin) redirect("/admin/login");
  const [{ data: subjects, error: subjectError }, { data: cards, error: cardError }, { data: units, error: unitError }, { data: topics, error: topicError }] = await Promise.all([
    client.database.from("subjects").select("id,name,slug,short_code,course_code,semester_number,description,accent_color,units_count,resources_count,sort_order,is_published").eq("course_code", "BMS").order("semester_number", { ascending: true }).order("sort_order", { ascending: true }),
    client.database.from("content_items").select("id,subject_id,content_type,title,description,body,academic_year,file_url,file_key,sort_order,is_published,flashcard_unit_id,flashcard_topic_id,question_document,answer_document").eq("content_type", "flashcard").order("sort_order", { ascending: true }),
    client.database.from("flashcard_units").select("id,subject_id,title,sort_order,is_published").order("sort_order", { ascending: true }),
    client.database.from("flashcard_topics").select("id,subject_id,unit_id,title,sort_order,is_published").order("sort_order", { ascending: true }),
  ]);
  const error = subjectError ?? cardError ?? unitError ?? topicError;
  return <AdminShell active="/admin/flashcards" email={user.email ?? "Admin"} eyebrow="ACTIVE RECALL" title="Flashcard management">
    <div className="admin-page-intro"><p>Create focused question-and-answer cards for every subject.</p><span>Only published cards appear to students.</span></div>
    {error ? <div className="admin-notice error">{error.message ?? "Could not load flashcards."}</div> : <FlashcardManager subjects={(subjects ?? []) as SubjectRecord[]} cards={(cards ?? []) as ContentRecord[]} units={(units ?? []) as FlashcardUnitRecord[]} topics={(topics ?? []) as FlashcardTopicRecord[]}/>}
  </AdminShell>;
}
