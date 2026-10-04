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
      <div className="admin-page-intro members-directory-strip">
        <div className="members-intro-icon-wrap" aria-hidden="true">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
            <path d="m9 12 2 2 4-4" />
          </svg>
        </div>
        <div className="members-intro-content">
          <span className="members-intro-title">Authentication Directory</span>
          <p>Registered student and educator accounts authenticated through InsForge.</p>
        </div>
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
