import Link from "next/link";
import { Logo } from "../components";
import { adminSignOut } from "./actions";

const groups = [
  { label: "WORKSPACE", items: [["/admin", "DB", "Dashboard"]] },
  { label: "ACADEMIC", items: [["/admin/semesters", "SE", "Semesters"], ["/admin/subjects", "SU", "Subjects"]] },
  { label: "CONTENT", items: [["/admin/content", "CO", "Study Content"], ["/admin/flashcards", "FC", "Flashcards"], ["/admin/pyqs", "PQ", "PYQs & PDFs"]] },
  { label: "COMMUNITY", items: [["/admin/feedback", "VO", "Feedback & Testimonials"]] },
];

export default function AdminShell({ active, email, eyebrow, title, children }: { active: string; email: string; eyebrow: string; title: string; children: React.ReactNode }) {
  return <main className="admin-dashboard">
    <aside className="admin-sidebar"><Logo/><nav>{groups.map((group) => <section key={group.label}><small>{group.label}</small>{group.items.map(([href, icon, label]) => <Link key={href} className={active === href ? "active" : ""} href={href}><span>{icon}</span>{label}</Link>)}</section>)}</nav><div className="admin-sidebar-foot"><small>SIGNED IN AS</small><b>{email}</b><form action={adminSignOut}><button type="submit">Sign out</button></form></div></aside>
    <header className="admin-mobile-header"><Logo/><div className="admin-mobile-actions"><Link href="/" target="_blank" aria-label="View live website">Live site ↗</Link><details className="admin-mobile-menu"><summary><span/><span/><small>Menu</small></summary><div><div className="admin-mobile-account"><span>SIGNED IN AS</span><b>{email}</b></div><nav>{groups.map((group) => <section key={group.label}><small>{group.label}</small>{group.items.map(([href, icon, label]) => <Link key={href} className={active === href ? "active" : ""} href={href}><span>{icon}</span><b>{label}</b><i>→</i></Link>)}</section>)}</nav><form action={adminSignOut}><button type="submit">Sign out</button></form></div></details></div></header>
    <section className="admin-workspace"><header><div><span>{eyebrow}</span><h1>{title}</h1></div><Link href="/" target="_blank">View live site ↗</Link></header>{children}</section>
  </main>;
}
