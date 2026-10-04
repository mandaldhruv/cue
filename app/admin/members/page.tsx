import { requireAdminSession } from "../../lib/insforge/server";
import AdminShell from "../AdminShell";
import type { MemberRecord, StudyTimeSummary } from "../types";
import MembersManager from "./MembersManager";

export const dynamic = "force-dynamic";

export default async function AdminMembersPage() {
  const { user, client } = await requireAdminSession();

  const [membersRes, studyStatsRes] = await Promise.all([
    client.database.rpc("get_cue_members"),
    client.database.rpc("get_cue_study_time_summary"),
  ]);

  const rawStats = Array.isArray(studyStatsRes.data)
    ? studyStatsRes.data[0]
    : studyStatsRes.data;

  const initialStudyStats: StudyTimeSummary = {
    today_seconds: Number(rawStats?.today_seconds || 0),
    week_seconds: Number(rawStats?.week_seconds || 0),
    month_seconds: Number(rawStats?.month_seconds || 0),
    all_time_seconds: Number(rawStats?.all_time_seconds || 0),
  };

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
      {membersRes.error ? (
        <div className="admin-notice error">{membersRes.error.message ?? "Could not load member data."}</div>
      ) : (
        <MembersManager
          members={(membersRes.data ?? []) as MemberRecord[]}
          initialStudyStats={initialStudyStats}
        />
      )}
    </AdminShell>
  );
}
