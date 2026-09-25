import { requireAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { MemberRecord } from "../types";
import MembersManager from "./MembersManager";

export const dynamic = "force-dynamic";

export default async function AdminMembersPage() {
  const { user, client } = await requireAdminSession();

  const { data, error } = await client.database.rpc("get_cue_members");

  return (
    <AdminShell
      active="/admin/members"
      email={user.email ?? "Admin"}
      eyebrow="COMMUNITY"
      title="Members & users"
    >
      <div className="admin-page-intro">
        <p>Registered student and educator accounts authenticated through InsForge.</p>
        <span>Authentication Directory</span>
      </div>
      {error ? (
        <div className="admin-notice error">{error.message ?? "Could not load member data."}</div>
      ) : (
        <MembersManager members={(data ?? []) as MemberRecord[]} />
      )}
    </AdminShell>
  );
}
