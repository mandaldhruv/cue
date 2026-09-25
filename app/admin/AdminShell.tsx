import Link from "next/link";
import { Logo } from "../components";
import { adminSignOut } from "./actions";
import { getAdminNotificationDataAction } from "./notifications/actions";
import { AdminNotificationProvider } from "./notifications/AdminNotificationContext";
import AdminNotificationBell from "./notifications/AdminNotificationBell";
import { AdminSidebarNav, type NavGroup } from "./notifications/AdminSidebarNav";

const groups: NavGroup[] = [
  { label: "WORKSPACE", items: [["/admin", "DB", "Dashboard"]] },
  { label: "ACADEMIC", items: [["/admin/semesters", "SE", "Semesters"], ["/admin/subjects", "SU", "Subjects"]] },
  { label: "CONTENT", items: [["/admin/syllabus", "SY", "Syllabus"], ["/admin/flashcards", "FC", "Flashcards"], ["/admin/pyqs", "PQ", "PYQs & PDFs"]] },
  { label: "COMMUNITY", items: [["/admin/members", "MB", "Members & Users"], ["/admin/feedback", "VO", "Feedback & Testimonials"]] },
];

export default async function AdminShell({
  active,
  email,
  eyebrow,
  title,
  children,
}: {
  active: string;
  email: string;
  eyebrow: string;
  title: React.ReactNode;
  children: React.ReactNode;
}) {
  const notifData = await getAdminNotificationDataAction();
  const initialCounts = notifData?.counts ?? {
    total: 0,
    members: 0,
    feedback: 0,
    content: 0,
    pyqs: 0,
  };
  const initialNotifications = notifData?.notifications ?? [];

  return (
    <AdminNotificationProvider
      initialCounts={initialCounts}
      initialNotifications={initialNotifications}
      activeRoute={active}
    >
      <main className="admin-dashboard">
        <aside className="admin-sidebar" aria-label="Admin Sidebar">
          <div className="admin-sidebar-head"><Logo/></div>
          <div className="admin-sidebar-scroll">
            <AdminSidebarNav groups={groups} active={active} />
            <div className="admin-sidebar-foot">
              <small>SIGNED IN AS</small>
              <b>{email}</b>
              <form action={adminSignOut}>
                <button type="submit">Sign out</button>
              </form>
            </div>
          </div>
        </aside>
        <header className="admin-mobile-header">
          <Logo/>
          <div className="admin-mobile-actions">
            <AdminNotificationBell className="admin-mobile-bell" />
            <Link href="/" target="_blank" aria-label="View live website">Live site ↗</Link>
            <details className="admin-mobile-menu">
              <summary>
                <span/><span/><small>Menu</small>
              </summary>
              <div className="admin-mobile-drawer">
                <div className="admin-mobile-account">
                  <span>SIGNED IN AS</span>
                  <b>{email}</b>
                </div>
                <AdminSidebarNav groups={groups} active={active} isMobile />
                <form action={adminSignOut}>
                  <button type="submit">Sign out</button>
                </form>
              </div>
            </details>
          </div>
        </header>
        <section className="admin-workspace">
          <header>
            <div>
              <span>{eyebrow}</span>
              <h1>{title}</h1>
            </div>
            <div className="admin-header-actions">
              <AdminNotificationBell />
              <Link href="/" target="_blank" className="admin-live-link">
                View live site ↗
              </Link>
            </div>
          </header>
          {children}
        </section>
      </main>
    </AdminNotificationProvider>
  );
}
