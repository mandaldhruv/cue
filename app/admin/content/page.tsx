import { redirect } from "next/navigation";
import { requireAdminSession } from "../../lib/insforge/server";

export const dynamic = "force-dynamic";

export default async function AdminContentRedirect() {
  await requireAdminSession();
  redirect("/admin/syllabus");
}
