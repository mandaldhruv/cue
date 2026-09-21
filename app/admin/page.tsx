import { redirect } from "next/navigation";
import Link from "next/link";
import { getAdminSession } from "../lib/insforge/server";
import AdminShell from "./AdminShell";
import AdminDashboardRefresh from "./AdminDashboardRefresh";
import { AdminGreeting } from "../greetings/GreetingDisplay";

export const dynamic = "force-dynamic";

type AdminActivity = { id: string; action: string; summary: string; entity_type: string; created_at: string };

const activityEntities: Record<string, { code: string; label: string }> = {
  semester: { code: "SE", label: "Semester" },
  subject: { code: "SU", label: "Subject" },
  content_item: { code: "CO", label: "Study content" },
  flashcard: { code: "FC", label: "Flashcard" },
  flashcard_unit: { code: "UN", label: "Flashcard unit" },
  flashcard_topic: { code: "TP", label: "Flashcard topic" },
  pyq: { code: "PDF", label: "PYQ & PDF" },
  feedback: { code: "FB", label: "Student feedback" },
  testimonial: { code: "VO", label: "Testimonial" },
};

const activityActions: Record<string, string> = {
  create: "Added",
  update: "Updated",
  delete: "Deleted",
  visibility: "Visibility changed",
  status: "Status changed",
  reorder: "Reordered",
};

function formatIst(value: string) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Time unavailable";
  return `${new Intl.DateTimeFormat("en-IN", {
    timeZone: "Asia/Kolkata",
    day: "2-digit",
    month: "short",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
    hour12: true,
  }).format(date)} IST`;
}

export default async function AdminDashboard() {
  const { user, isAdmin, client } = await getAdminSession();
  if (!user || !isAdmin) redirect("/admin/login");
  const [{ data: semesters }, { data: subjects }, { data: content }, { data: feedback }, { data: activity }] = await Promise.all([
    client.database.from("semesters").select("id,status"),
    client.database.from("subjects").select("id,name,slug,semester_number,is_published").eq("course_code", "BMS").order("semester_number", { ascending: true }),
    client.database.from("content_items").select("id,subject_id,content_type,is_published"),
    client.database.from("feedback_submissions").select("id,status"),
    client.database.from("admin_activity").select("id,action,summary,entity_type,created_at").order("created_at", { ascending: false }).limit(8),
  ]);
  const publishedContent = content?.filter((item: { is_published: boolean }) => item.is_published).length ?? 0;
  const draftContent = (content?.length ?? 0) - publishedContent;
  const newFeedback = feedback?.filter((item: { status: string }) => item.status === "new").length ?? 0;
  const needsAttention = (subjects ?? []).map((subject: { id: string; name: string; slug: string; semester_number: number; is_published: boolean }) => {
    const items = content?.filter((item: { subject_id: string }) => item.subject_id === subject.id) ?? [];
    const missing = ["syllabus_unit", "note", "flashcard", "pyq"].filter((type) => !items.some((item: { content_type: string; is_published: boolean }) => item.content_type === type && item.is_published));
    return { ...subject, missing };
  }).filter((subject: { is_published: boolean; missing: string[] }) => subject.is_published && subject.missing.length).slice(0, 5);
  return <AdminShell active="/admin" email={user.email ?? "Admin"} eyebrow="CUE ADMIN" title={<AdminGreeting fallback="Your publishing dashboard" />}>
      <AdminDashboardRefresh />
      <div className="admin-stat-grid actionable"><article><span>PUBLISHED SUBJECTS</span><b>{subjects?.filter((item: { is_published: boolean }) => item.is_published).length ?? 0}</b><p>{subjects?.length ?? 0} total subjects</p></article><article><span>LIVE MATERIAL</span><b>{publishedContent}</b><p>{draftContent} drafts waiting</p></article><article><span>NEW FEEDBACK</span><b>{newFeedback}</b><p>{feedback?.length ?? 0} total responses</p></article><article><span>AVAILABLE SEMESTERS</span><b>{semesters?.filter((item: { status: string }) => item.status === "published").length ?? 0}</b><p>{semesters?.length ?? 0} configured</p></article></div>
      <div className="admin-dashboard-grid practical"><section><div className="admin-panel-title"><div><span>QUICK ACTIONS</span><h2>What do you want to update?</h2></div></div><div className="admin-quick-grid">{[["01","Study content","Syllabus, notes, exam focus and resources.","/admin/content"],["02","PYQs & PDFs","Upload and publish a real exam paper.","/admin/pyqs"],["03","Flashcards","Build a subject revision deck.","/admin/flashcards"],["04","Feedback","Review student responses and testimonials.","/admin/feedback"]].map((item)=><Link href={item[3]} key={item[0]}><span>{item[0]}</span><div><b>{item[1]}</b><p>{item[2]}</p></div><i>→</i></Link>)}</div></section><aside className="attention-panel"><span>NEEDS ATTENTION</span><h2>Published but incomplete</h2>{needsAttention.length ? needsAttention.map((subject: { id: string; name: string; semester_number: number; missing: string[] }) => <Link href="/admin/content" key={subject.id}><div><b>{subject.name}</b><small>Semester {subject.semester_number} · Missing {subject.missing.map((item) => item === "syllabus_unit" ? "syllabus" : item).join(", ")}</small></div><i>→</i></Link>) : <p>Every published subject has its core material.</p>}</aside></div>
      <section className="recent-admin-activity"><div className="admin-panel-title"><div><span>RECENT ACTIVITY · IST</span><h2>Latest changes</h2></div></div>{activity?.length ? <div>{(activity as AdminActivity[]).map((item) => { const entity = activityEntities[item.entity_type] ?? { code: item.entity_type.slice(0, 2).toUpperCase(), label: item.entity_type.replaceAll("_", " ") }; return <article key={item.id}><span>{entity.code}</span><div><small className="activity-context">{activityActions[item.action] ?? item.action} · {entity.label}</small><b>{item.summary}</b><small>{formatIst(item.created_at)}</small></div></article>; })}</div> : <p>No admin activity recorded yet.</p>}</section>
  </AdminShell>;
}
