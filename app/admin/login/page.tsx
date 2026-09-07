import Link from "next/link";
import { redirect } from "next/navigation";
import { Logo } from "../../components";
import { getAdminSession } from "../../lib/insforge/server";
import AdminLoginForm from "./AdminLoginForm";

export const dynamic = "force-dynamic";

export default async function AdminLoginPage() {
  const { isAdmin } = await getAdminSession();
  if (isAdmin) redirect("/admin");
  return <main className="admin-login"><div className="admin-login-brand"><Logo/><Link href="/">← Back to website</Link></div><div className="admin-login-grid"><section><span className="eyebrow">CUE ADMIN</span><h1>Keep every resource<br/><em>accurate and organised.</em></h1><p>A secure private workspace for Cue’s semesters, subjects, notes, PDFs, flashcards and exam material.</p><div className="admin-preview-list"><span><b>01</b> Verified owner access</span><span><b>02</b> Protected content</span><span><b>03</b> Activity history</span></div></section><AdminLoginForm/></div></main>;
}
