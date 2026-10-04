import Link from "next/link";
import { randomUUID } from "node:crypto";
import { requireAdminSession } from "../lib/insforge/server";
import AdminShell from "./AdminShell";
import AdminDashboardRefresh from "./AdminDashboardRefresh";
import { AdminGreeting } from "../greetings/GreetingDisplay";
import greetingMessages from "../greetings/greeting-messages.generated.json";

export const dynamic = "force-dynamic";

type AdminActivity = { id: string; action: string; summary: string; entity_type: string; created_at: string };

const activityEntities: Record<string, { code: string; label: string }> = {
  semester: { code: "SE", label: "Semester" },
  subject: { code: "SU", label: "Subject" },
  content_item: { code: "SY", label: "Syllabus" },
  syllabus_unit: { code: "SY", label: "Syllabus unit" },
  flashcard: { code: "FC", label: "Flashcard" },
  flashcard_unit: { code: "UN", label: "Flashcard unit" },
  flashcard_topic: { code: "TP", label: "Flashcard topic" },
  pyq: { code: "PDF", label: "PYQ & PDF" },
  feedback: { code: "FB", label: "Student feedback" },
  testimonial: { code: "VO", label: "Testimonial" },
  member: { code: "MB", label: "Member" },
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

function countRecentMembers(members: { created_at: string }[] | null) {
  if (!members?.length) return 0;
  const cutoff = Date.now() - 7 * 24 * 60 * 60 * 1000;
  return members.filter((m) => new Date(m.created_at).getTime() > cutoff).length;
}

function StudyBooksVisual() {
  return (
    <svg
      width="210"
      height="135"
      viewBox="0 0 220 145"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="admin-hero-illustration"
      aria-hidden="true"
    >
      <ellipse cx="112" cy="133" rx="88" ry="7" fill="rgba(37, 99, 235, 0.08)" />

      {/* Small ceramic sprout pot */}
      <ellipse cx="40" cy="120" rx="14" ry="4" fill="rgba(15, 23, 42, 0.06)" />
      <path d="M30 106 L33 120 C33 122 47 122 47 120 L50 106 Z" fill="#ffffff" stroke="#cbd5e1" strokeWidth="1.5" />
      <ellipse cx="40" cy="106" rx="10" ry="2.5" fill="#f1f5f9" stroke="#cbd5e1" strokeWidth="1.5" />
      <path d="M40 105 C38 90 28 85 24 86 C26 95 34 100 40 105 Z" fill="#22c55e" />
      <path d="M40 105 C42 86 52 82 56 84 C54 93 46 99 40 105 Z" fill="#16a34a" />
      <path d="M40 103 C40 80 43 74 46 72 C46 82 43 92 40 103 Z" fill="#4ade80" />

      {/* Bottom book (Navy) */}
      <g>
        <path d="M72 108 L188 108 C192 108 196 111 196 115 L196 127 C196 130 192 132 188 132 L72 132 C68 132 64 130 64 127 L64 115 C64 111 68 108 72 108 Z" fill="#1e293b" />
        <rect x="74" y="112" width="118" height="16" rx="2" fill="#f8fafc" stroke="#e2e8f0" strokeWidth="1" />
        <line x1="192" y1="114" x2="192" y2="126" stroke="#cbd5e1" strokeWidth="1" strokeDasharray="2 2" />
        <path d="M64 112 C64 110 67 108 71 108 L76 108 L76 132 L71 132 C67 132 64 130 64 128 Z" fill="#334155" />
      </g>

      {/* Middle book (Amber) */}
      <g>
        <path d="M80 84 L184 84 C188 84 191 87 191 90 L191 102 C191 105 188 108 184 108 L80 108 C76 108 73 105 73 102 L73 90 C73 87 76 84 80 84 Z" fill="#f59e0b" />
        <rect x="82" y="88" width="105" height="16" rx="2" fill="#ffffff" stroke="#fef3c7" strokeWidth="1" />
        <path d="M73 88 C73 86 76 84 79 84 L84 84 L84 108 L79 108 C76 108 73 106 73 104 Z" fill="#d97706" />
        <path d="M140 108 L140 125 L144 122 L148 125 L148 108 Z" fill="#ef4444" />
      </g>

      {/* Top book (Cue Blue) */}
      <g>
        <path d="M86 60 L176 60 C180 60 184 63 184 67 L184 78 C184 82 180 85 176 85 L86 85 C82 85 78 82 78 78 L78 67 C78 63 82 60 86 60 Z" fill="#2563eb" />
        <rect x="88" y="64" width="92" height="17" rx="2" fill="#f8fafc" stroke="#dbeafe" strokeWidth="1" />
        <path d="M78 64 C78 62 81 60 85 60 L90 60 L90 85 L85 85 C81 85 78 83 78 81 Z" fill="#1d4ed8" />
        <line x1="84" y1="65" x2="84" y2="80" stroke="#60a5fa" strokeWidth="1.5" strokeLinecap="round" />
        <path d="M120 85 L120 99 L124 96 L128 99 L128 85 Z" fill="#3b82f6" />
      </g>

      {/* Subtle sparkle accents */}
      <path d="M195 48 Q200 48 200 43 Q200 48 205 48 Q200 48 200 53 Q200 48 195 48 Z" fill="#93c5fd" />
      <path d="M68 52 Q71 52 71 49 Q71 52 74 52 Q71 52 71 55 Q71 52 68 52 Z" fill="#60a5fa" />
    </svg>
  );
}

function QuickActionIcon({ href }: { href: string }) {
  switch (href) {
    case "/admin/syllabus":
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
          <polyline points="14 2 14 8 20 8" />
          <line x1="16" y1="13" x2="8" y2="13" />
          <line x1="16" y1="17" x2="8" y2="17" />
          <line x1="10" y1="9" x2="8" y2="9" />
        </svg>
      );
    case "/admin/pyqs":
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z" />
          <polyline points="14 2 14 8 20 8" />
          <path d="M12 18v-6" />
          <path d="m9 15 3 3 3-3" />
        </svg>
      );
    case "/admin/flashcards":
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <rect x="3" y="7" width="14" height="14" rx="2" />
          <path d="M7 3h12a2 2 0 0 1 2 2v12" />
          <path d="M7 11h6" />
        </svg>
      );
    case "/admin/feedback":
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
          <line x1="8" y1="10" x2="16" y2="10" />
          <line x1="8" y1="14" x2="13" y2="14" />
        </svg>
      );
    case "/admin/members":
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
          <circle cx="9" cy="7" r="4" />
          <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
          <path d="M16 3.13a4 4 0 0 1 0 7.75" />
        </svg>
      );
    default:
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <circle cx="12" cy="12" r="9" />
          <path d="m9 12 2 2 4-4" />
        </svg>
      );
  }
}

function ActivityIcon({ entityType }: { entityType: string }) {
  switch (entityType) {
    case "testimonial":
      return (
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
          <path d="M9 10h.01M15 10h.01" />
        </svg>
      );
    case "feedback":
      return (
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
          <line x1="8" y1="10" x2="16" y2="10" />
          <line x1="8" y1="14" x2="13" y2="14" />
        </svg>
      );
    case "flashcard":
    case "flashcard_unit":
    case "flashcard_topic":
      return (
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <rect x="3" y="7" width="14" height="14" rx="2" />
          <path d="M7 3h12a2 2 0 0 1 2 2v12" />
        </svg>
      );
    case "content_item":
    case "syllabus_unit":
      return (
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
          <polyline points="14 2 14 8 20 8" />
          <line x1="16" y1="13" x2="8" y2="13" />
        </svg>
      );
    case "pyq":
      return (
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z" />
          <polyline points="14 2 14 8 20 8" />
          <path d="M12 18v-6" />
          <path d="m9 15 3 3 3-3" />
        </svg>
      );
    case "member":
      return (
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
          <circle cx="9" cy="7" r="4" />
          <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
          <path d="M16 3.13a4 4 0 0 1 0 7.75" />
        </svg>
      );
    default:
      return (
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z" />
          <path d="M6 6h10" />
          <path d="M6 10h10" />
        </svg>
      );
  }
}

function activityColorClass(entityType: string): string {
  switch (entityType) {
    case "content_item":
    case "syllabus_unit":
      return "icon-blue";
    case "pyq":
      return "icon-green";
    case "flashcard":
    case "flashcard_unit":
    case "flashcard_topic":
      return "icon-purple";
    case "testimonial":
    case "feedback":
      return "icon-amber";
    case "member":
      return "icon-rose";
    default:
      return "icon-blue";
  }
}

export default async function AdminDashboard() {
  const { user, client } = await requireAdminSession();
  const [{ data: semesters }, { data: subjects }, { data: content }, { data: feedback }, { data: members }, { data: activity }] = await Promise.all([
    client.database.from("semesters").select("id,status"),
    client.database.from("subjects").select("id,name,slug,semester_number,is_published").eq("course_code", "BMS").order("semester_number", { ascending: true }),
    client.database.from("content_items").select("id,subject_id,content_type,is_published"),
    client.database.from("feedback_submissions").select("id,status"),
    client.database.rpc("get_cue_members"),
    client.database.from("admin_activity").select("id,action,summary,entity_type,created_at").order("created_at", { ascending: false }).limit(8),
  ]);

  // Resolve admin dynamic greeting server-side to prevent "Your Publishing Dashboard" flash
  let initialGreeting: string | null = null;
  let initialGreetingTimeBlock: number | null = null;
  try {
    const { data: greetingData } = await client.database.rpc("reserve_cue_greeting", {
      p_audience: "admin",
      p_event_id: randomUUID(),
    });
    const reservation = (Array.isArray(greetingData) ? greetingData[0] : greetingData) as { time_block: number; message_index: number } | null;
    if (reservation?.time_block && reservation?.message_index !== undefined) {
      const blockIndex = Number(reservation.time_block) - 1;
      const messageIndex = Number(reservation.message_index);
      const source = (greetingMessages.admin as string[][]);
      const sourceMessage = source[blockIndex]?.[messageIndex];
      if (sourceMessage) {
        initialGreeting = sourceMessage;
        initialGreetingTimeBlock = blockIndex + 1;
      }
    }
  } catch (err) {
    console.error("Admin greeting reservation error", err);
  }

  // Graceful fallback to current IST time block if reservation is unavailable
  if (!initialGreeting) {
    const currentHourIst = new Date(new Date().toLocaleString("en-US", { timeZone: "Asia/Kolkata" })).getHours();
    const fallbackBlockIndex = Math.min(7, Math.max(0, Math.floor(currentHourIst / 3)));
    initialGreetingTimeBlock = fallbackBlockIndex + 1;
    const adminMessages = (greetingMessages.admin as string[][])[fallbackBlockIndex];
    if (adminMessages?.length) {
      initialGreeting = adminMessages[0];
    }
  }

  const publishedContent = content?.filter((item: { is_published: boolean }) => item.is_published).length ?? 0;
  const draftContent = (content?.length ?? 0) - publishedContent;
  const syllabusCount = content?.filter((item: { content_type: string; is_published: boolean }) => item.content_type === "syllabus_unit" && item.is_published).length ?? 0;
  const pyqCount = content?.filter((item: { content_type: string; is_published: boolean }) => item.content_type === "pyq" && item.is_published).length ?? 0;
  const flashcardCount = content?.filter((item: { content_type: string; is_published: boolean }) => item.content_type === "flashcard" && item.is_published).length ?? 0;
  const newFeedback = feedback?.filter((item: { status: string }) => item.status === "new").length ?? 0;
  const totalMembers = members?.length ?? 0;
  const newMembersThisWeek = countRecentMembers(members as { created_at: string }[] | null);

  const quickAccessItems = [
    ["01", "Syllabus", "Manage units and detailed topic coverage.", "/admin/syllabus", "icon-blue"],
    ["02", "PYQs & PDFs", "Upload and publish verified exam papers.", "/admin/pyqs", "icon-green"],
    ["03", "Flashcards", "Build subject revision decks.", "/admin/flashcards", "icon-purple"],
    ["04", "Feedback & Testimonials", "Review student responses and testimonials.", "/admin/feedback", "icon-amber"],
    ["05", "Members & Users", "View registered accounts, roles and signups.", "/admin/members", "icon-rose"],
  ];

  const contentOverviewItems = [
    {
      title: "Curriculum Units",
      detail: `${syllabusCount} published syllabus units`,
      badge: `${syllabusCount} live`,
      href: "/admin/syllabus",
      color: "icon-blue",
    },
    {
      title: "Previous Year Papers",
      detail: `${pyqCount} past question papers & solutions`,
      badge: `${pyqCount} papers`,
      href: "/admin/pyqs",
      color: "icon-green",
    },
    {
      title: "Active Flashcards",
      detail: `${flashcardCount} cards in active revision decks`,
      badge: `${flashcardCount} cards`,
      href: "/admin/flashcards",
      color: "icon-purple",
    },
    {
      title: "Student Feedback",
      detail: `${feedback?.length ?? 0} total responses (${newFeedback} new)`,
      badge: newFeedback > 0 ? `${newFeedback} new` : `${feedback?.length ?? 0} total`,
      href: "/admin/feedback",
      color: "icon-amber",
    },
    {
      title: "Registered Members",
      detail: `${totalMembers} student accounts (${newMembersThisWeek} this week)`,
      badge: `${totalMembers} users`,
      href: "/admin/members",
      color: "icon-rose",
    },
  ];

  return (
    <AdminShell active="/admin" email={user.email ?? "Admin"} title="Dashboard">
      <AdminDashboardRefresh />

      <div className="admin-dashboard-flow">
        {/* Dynamic Greeting Hero Banner */}
        <div className="admin-greeting-hero">
          <div className="admin-greeting-hero-content">
            <div className="admin-greeting-tag">
              <span className="admin-greeting-tag-dot" aria-hidden="true" />
              <span>Cue Admin Workspace</span>
            </div>
            <div className="admin-greeting-text">
              <AdminGreeting
                initialUserId={user.id}
                initialMessage={initialGreeting}
                initialTimeBlock={initialGreetingTimeBlock}
                fallback="Your publishing dashboard"
              />
            </div>
          </div>
          <div className="admin-greeting-hero-visual" aria-hidden="true">
            <StudyBooksVisual />
          </div>
        </div>

        {/* 5 Statistics Cards */}
        <div className="admin-stat-grid actionable">
          <article className="stat-card-subjects">
            <div className="admin-stat-top">
              <div className="admin-stat-icon-wrap icon-blue" aria-hidden="true">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z" />
                  <path d="M6 6h10" />
                  <path d="M6 10h10" />
                </svg>
              </div>
            </div>
            <span>PUBLISHED SUBJECTS</span>
            <b>{subjects?.filter((item: { is_published: boolean }) => item.is_published).length ?? 0}</b>
            <p>{subjects?.length ?? 0} total subjects</p>
          </article>

          <article className="stat-card-content">
            <div className="admin-stat-top">
              <div className="admin-stat-icon-wrap icon-green" aria-hidden="true">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M12 2 2 7l10 5 10-5-10-5Z" />
                  <path d="m2 17 10 5 10-5" />
                  <path d="m2 12 10 5 10-5" />
                </svg>
              </div>
            </div>
            <span>LIVE MATERIAL</span>
            <b>{publishedContent}</b>
            <p>{draftContent} drafts waiting</p>
          </article>

          <article className="stat-card-feedback">
            <div className="admin-stat-top">
              <div className="admin-stat-icon-wrap icon-purple" aria-hidden="true">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
                  <line x1="8" y1="10" x2="16" y2="10" />
                  <line x1="8" y1="14" x2="13" y2="14" />
                </svg>
              </div>
            </div>
            <span>NEW FEEDBACK</span>
            <b>{newFeedback}</b>
            <p>{feedback?.length ?? 0} total responses</p>
          </article>

          <article className="stat-card-members">
            <div className="admin-stat-top">
              <div className="admin-stat-icon-wrap icon-amber" aria-hidden="true">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                  <circle cx="9" cy="7" r="4" />
                  <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
                  <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                </svg>
              </div>
            </div>
            <span>TOTAL MEMBERS</span>
            <b>{totalMembers}</b>
            <p>{newMembersThisWeek} joined this week</p>
          </article>

          <article className="stat-card-semesters">
            <div className="admin-stat-top">
              <div className="admin-stat-icon-wrap icon-rose" aria-hidden="true">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                  <line x1="16" y1="2" x2="16" y2="6" />
                  <line x1="8" y1="2" x2="8" y2="6" />
                  <line x1="3" y1="10" x2="21" y2="10" />
                  <path d="m9 16 2 2 4-4" />
                </svg>
              </div>
            </div>
            <span>AVAILABLE SEMESTERS</span>
            <b>{semesters?.filter((item: { status: string }) => item.status === "published").length ?? 0}</b>
            <p>{semesters?.length ?? 0} configured</p>
          </article>
        </div>

        {/* Quick Access + Content Overview Grid */}
        <div className="admin-dashboard-grid practical">
          <section className="quick-access-panel">
            <div className="admin-panel-title">
              <h2>Quick Access</h2>
            </div>
            <div className="admin-quick-grid">
              {quickAccessItems.map(([id, title, desc, href, color]) => (
                <Link href={href} key={id} className="admin-quick-card">
                  <div className={`admin-quick-icon-wrap ${color}`} aria-hidden="true">
                    <QuickActionIcon href={href} />
                  </div>
                  <div className="admin-quick-copy">
                    <b>{title}</b>
                    <p>{desc}</p>
                  </div>
                </Link>
              ))}
            </div>
          </section>

          <section className="content-overview-panel">
            <div className="admin-panel-title">
              <h2>Content Overview</h2>
            </div>
            <div className="admin-overview-grid">
              {contentOverviewItems.map((item) => (
                <Link href={item.href} key={item.title} className="admin-overview-card">
                  <div className={`admin-overview-icon-wrap ${item.color}`} aria-hidden="true">
                    <QuickActionIcon href={item.href} />
                  </div>
                  <div className="admin-overview-copy">
                    <b>{item.title}</b>
                    <p>{item.detail}</p>
                  </div>
                  <span className={`admin-overview-badge ${item.color}`}>{item.badge}</span>
                </Link>
              ))}
            </div>
          </section>
        </div>

        {/* Recent Activity / Latest Changes */}
        <section className="recent-admin-activity">
          <div className="admin-panel-title">
            <div>
              <h2>Latest Changes</h2>
              <small className="admin-panel-subtitle">Recorded in real time · Indian Standard Time (IST)</small>
            </div>
          </div>

          {activity?.length ? (
            <div className="admin-activity-grid">
              {(activity as AdminActivity[]).map((item) => {
                const entity = activityEntities[item.entity_type] ?? {
                  code: item.entity_type.slice(0, 2).toUpperCase(),
                  label: item.entity_type.replaceAll("_", " "),
                };
                const colorClass = activityColorClass(item.entity_type);
                return (
                  <article key={item.id} className="admin-activity-card">
                    <div className={`admin-activity-icon-wrap ${colorClass}`} aria-hidden="true">
                      <ActivityIcon entityType={item.entity_type} />
                    </div>
                    <div className="admin-activity-info">
                      <span className="activity-context">
                        {activityActions[item.action] ?? item.action} · {entity.label}
                      </span>
                      <b>{item.summary}</b>
                      <small className="activity-time">{formatIst(item.created_at)}</small>
                    </div>
                  </article>
                );
              })}
            </div>
          ) : (
            <div className="admin-activity-empty">
              <p>No admin activity recorded yet.</p>
            </div>
          )}
        </section>
      </div>
    </AdminShell>
  );
}
