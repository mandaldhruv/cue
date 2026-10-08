import { requireAdminSession } from "../../lib/supabase/server";
import AdminShell from "../AdminShell";
import type { MemberRecord, StudyTimeSummary } from "../types";
import MembersManager from "./MembersManager";

export const dynamic = "force-dynamic";

export default async function AdminMembersPage() {
  const { user, client } = await requireAdminSession();

  const { data: members, error: membersError } = await client.rpc("get_cue_members");

  const initialStudyStats: StudyTimeSummary = {
    today_seconds: 0,
    week_seconds: 0,
    month_seconds: 0,
    all_time_seconds: 0,
  };

  return (
    <AdminShell
      active="/admin/members"
      email={user.email ?? "Admin"}
      title="Members & Users"
    >
      {membersError ? (
        <div className="admin-notice error">{membersError.message ?? "Could not load member data."}</div>
      ) : (
        <MembersManager
          members={(members ?? []) as MemberRecord[]}
          initialStudyStats={initialStudyStats}
        />
      )}
    </AdminShell>
  );
}
