"use client";

import { useEffect, useMemo, useState } from "react";
import type { MemberRecord, UserSessionRecord } from "../types";

function initials(name: string) {
  if (!name) return "CU";
  const parts = name.trim().split(/\s+/);
  if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
  return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}

function formatIst(value: string | null) {
  if (!value) return "Never active";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Invalid date";
  return new Intl.DateTimeFormat("en-IN", {
    timeZone: "Asia/Kolkata",
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
    hour12: true,
  }).format(date);
}

function formatSessionTime(value: string | null) {
  if (!value) return "--";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "--";
  return new Intl.DateTimeFormat("en-IN", {
    timeZone: "Asia/Kolkata",
    hour: "numeric",
    minute: "2-digit",
    hour12: true,
  }).format(date);
}

function formatStudyTime(secondsInput?: number | string | null) {
  const seconds = Number(secondsInput || 0);
  if (!seconds || seconds <= 0) return "0m";
  if (seconds < 60) return "< 1m";
  const totalMinutes = Math.floor(seconds / 60);
  if (totalMinutes < 60) return `${totalMinutes}m`;
  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;
  if (minutes === 0) return `${hours}h`;
  return `${hours}h ${minutes}m`;
}

function timeAgo(value: string | null) {
  if (!value) return "No activity yet";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "Unknown";
  const diffSec = Math.floor((Date.now() - date.getTime()) / 1000);
  if (diffSec < 60) return "Just now";
  if (diffSec < 3600) return `${Math.floor(diffSec / 60)}m ago`;
  if (diffSec < 86400) return `${Math.floor(diffSec / 3600)}h ago`;
  if (diffSec < 86400 * 7) return `${Math.floor(diffSec / 86400)}d ago`;
  return formatIst(value);
}

function isWithinHours(dateStr: string, hours: number) {
  const date = new Date(dateStr);
  return Date.now() - date.getTime() <= hours * 60 * 60 * 1000;
}

function isWithinDays(dateStr: string, days: number) {
  const date = new Date(dateStr);
  return Date.now() - date.getTime() <= days * 24 * 60 * 60 * 1000;
}

export default function MembersManager({ members }: { members: MemberRecord[] }) {
  const [search, setSearch] = useState("");
  const [roleFilter, setRoleFilter] = useState<string>("all");
  const [statusFilter, setStatusFilter] = useState<string>("all");
  const [sortKey, setSortKey] = useState<"newest" | "oldest" | "name" | "active" | "study_time">("newest");

  // Selected member for detail modal
  const [selectedMember, setSelectedMember] = useState<MemberRecord | null>(null);
  const [sessionsLoading, setSessionsLoading] = useState(false);
  const [recentSessions, setRecentSessions] = useState<UserSessionRecord[]>([]);

  // Load sessions when a member is selected
  useEffect(() => {
    if (!selectedMember) {
      setRecentSessions([]);
      return;
    }

    let isMounted = true;
    setSessionsLoading(true);

    fetch(`/api/admin/members/${selectedMember.id}/activity`)
      .then((res) => (res.ok ? res.json() : Promise.reject(new Error("Failed to load"))))
      .then((data) => {
        if (isMounted) {
          setRecentSessions(data.sessions || []);
        }
      })
      .catch(() => {
        if (isMounted) setRecentSessions([]);
      })
      .finally(() => {
        if (isMounted) setSessionsLoading(false);
      });

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") setSelectedMember(null);
    };
    window.addEventListener("keydown", handleKeyDown);

    return () => {
      isMounted = false;
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [selectedMember]);

  // Metrics
  const totalCount = members.length;
  const newTodayCount = useMemo(() => members.filter((m) => isWithinHours(m.created_at, 24)).length, [members]);
  const newThisWeekCount = useMemo(() => members.filter((m) => isWithinDays(m.created_at, 7)).length, [members]);
  const verifiedCount = useMemo(() => members.filter((m) => m.email_verified).length, [members]);
  const activeRecentCount = useMemo(() => {
    return members.filter((m) => {
      const activeTime = m.last_seen || m.created_at;
      return isWithinDays(activeTime, 7);
    }).length;
  }, [members]);

  // Filtered and sorted members
  const visibleMembers = useMemo(() => {
    const query = search.trim().toLowerCase();
    return members
      .filter((member) => {
        if (query) {
          const matchName = member.name.toLowerCase().includes(query);
          const matchEmail = member.email.toLowerCase().includes(query);
          if (!matchName && !matchEmail) return false;
        }
        if (roleFilter !== "all") {
          const isRoleAdmin = member.role.toLowerCase().includes("admin");
          if (roleFilter === "admin" && !isRoleAdmin) return false;
          if (roleFilter === "student" && isRoleAdmin) return false;
        }
        if (statusFilter === "verified" && !member.email_verified) return false;
        if (statusFilter === "unverified" && member.email_verified) return false;
        return true;
      })
      .sort((a, b) => {
        if (sortKey === "newest") {
          return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
        }
        if (sortKey === "oldest") {
          return new Date(a.created_at).getTime() - new Date(b.created_at).getTime();
        }
        if (sortKey === "name") {
          return a.name.localeCompare(b.name);
        }
        if (sortKey === "study_time") {
          const aSeconds = Number(a.total_study_seconds || 0);
          const bSeconds = Number(b.total_study_seconds || 0);
          return bSeconds - aSeconds;
        }
        if (sortKey === "active") {
          const aTime = new Date(a.last_seen || a.created_at).getTime();
          const bTime = new Date(b.last_seen || b.created_at).getTime();
          return bTime - aTime;
        }
        return 0;
      });
  }, [members, search, roleFilter, statusFilter, sortKey]);

  return (
    <>
      <section className="members-stat-grid" aria-label="Member metrics">
        <article className="members-stat-card">
          <span>TOTAL MEMBERS</span>
          <b>{totalCount}</b>
          <p>{verifiedCount} verified accounts</p>
        </article>
        <article className="members-stat-card highlight">
          <span>NEW TODAY</span>
          <b>{newTodayCount}</b>
          <p>{newThisWeekCount} joined in last 7 days</p>
        </article>
        <article className="members-stat-card">
          <span>ACTIVE THIS WEEK</span>
          <b>{activeRecentCount}</b>
          <p>Recent logins & study activity</p>
        </article>
        <article className="members-stat-card">
          <span>EMAIL VERIFICATION</span>
          <b>{totalCount ? Math.round((verifiedCount / totalCount) * 100) : 0}%</b>
          <p>{totalCount - verifiedCount} pending verification</p>
        </article>
      </section>

      {newThisWeekCount > 0 && (
        <aside className="members-new-banner">
          <div className="members-new-banner-icon">✦</div>
          <div className="members-new-banner-content">
            <b>{newThisWeekCount} new {newThisWeekCount === 1 ? "member" : "members"} joined this week</b>
            <p>Welcome your newest BMS students and educators. Newly registered accounts are highlighted with a badge below.</p>
          </div>
        </aside>
      )}

      <div className="members-toolbar">
        <div className="members-search-wrap">
          <span className="members-search-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none">
              <circle cx="11" cy="11" r="7" stroke="currentColor" strokeWidth="2" />
              <path d="m20 20-3.5-3.5" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
            </svg>
          </span>
          <input
            type="search"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by name or email address…"
            aria-label="Search members"
          />
          {search && (
            <button type="button" onClick={() => setSearch("")} aria-label="Clear search">
              ×
            </button>
          )}
        </div>

        <div className="members-filters">
          <label>
            <span>ROLE</span>
            <select value={roleFilter} onChange={(e) => setRoleFilter(e.target.value)}>
              <option value="all">All Roles</option>
              <option value="student">Students</option>
              <option value="admin">Administrators</option>
            </select>
          </label>

          <label>
            <span>STATUS</span>
            <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
              <option value="all">All Status</option>
              <option value="verified">Verified only</option>
              <option value="unverified">Pending only</option>
            </select>
          </label>

          <label>
            <span>SORT</span>
            <select value={sortKey} onChange={(e) => setSortKey(e.target.value as any)}>
              <option value="newest">Newest first</option>
              <option value="active">Recently active</option>
              <option value="study_time">Most study time</option>
              <option value="name">Name A-Z</option>
              <option value="oldest">Oldest first</option>
            </select>
          </label>
        </div>
      </div>

      <div className="members-count-summary">
        Showing <b>{visibleMembers.length}</b> of <b>{totalCount}</b> registered {totalCount === 1 ? "member" : "members"}
      </div>

      <div className="members-table-card">
        <div className="members-table-head">
          <span>MEMBER</span>
          <span>EMAIL</span>
          <span>ROLE</span>
          <span>STUDY TIME</span>
          <span>REGISTRATION DATE</span>
          <span>LAST ACTIVE</span>
        </div>

        {visibleMembers.length ? (
          visibleMembers.map((member) => {
            const isRecent = isWithinDays(member.created_at, 7);
            const isToday = isWithinHours(member.created_at, 24);
            const isAdmin = member.role.toLowerCase().includes("admin");
            const lastActiveTime = member.last_seen || member.created_at;
            const studySeconds = Number(member.total_study_seconds || 0);

            return (
              <div
                className={`members-table-row clickable-row ${isRecent ? "is-new-member" : ""}`}
                key={member.id}
                onClick={() => setSelectedMember(member)}
                role="button"
                tabIndex={0}
                onKeyDown={(e) => {
                  if (e.key === "Enter" || e.key === " ") {
                    e.preventDefault();
                    setSelectedMember(member);
                  }
                }}
                aria-label={`View activity for ${member.name}`}
              >
                {/* Column 1: Member Name & Avatar */}
                <div className="members-col-name">
                  <span className={`members-avatar ${isAdmin ? "avatar-admin" : ""}`}>
                    {initials(member.name)}
                  </span>
                  <div className="members-name-info">
                    <b title={member.name}>{member.name}</b>
                    {isToday ? (
                      <span className="members-new-pill today">NEW TODAY</span>
                    ) : isRecent ? (
                      <span className="members-new-pill week">NEW THIS WEEK</span>
                    ) : null}
                  </div>
                </div>

                {/* Column 2: Email */}
                <div className="members-col-email">
                  <span title={member.email}>{member.email}</span>
                </div>

                {/* Column 3: Role */}
                <div className="members-col-role">
                  <span className={`members-role-badge ${isAdmin ? "badge-admin" : "badge-student"}`}>
                    {member.role}
                  </span>
                </div>

                {/* Column 4: Study Time (Replaces Account Status) */}
                <div className="members-col-study-time">
                  <span className="members-mobile-label">STUDY TIME</span>
                  <span className={`members-study-pill ${studySeconds > 0 ? "has-time" : "zero-time"}`}>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                      <circle cx="12" cy="12" r="10" />
                      <polyline points="12 6 12 12 16 14" />
                    </svg>
                    <b>{formatStudyTime(studySeconds)}</b>
                  </span>
                </div>

                {/* Column 5 & 6: Registration Date & Last Active */}
                <div className="members-dates-grid">
                  <div className="members-col-registered">
                    <span className="members-mobile-label">REGISTRATION DATE</span>
                    <b>{formatIst(member.created_at)}</b>
                    <small>{timeAgo(member.created_at)}</small>
                  </div>

                  <div className="members-col-active">
                    <span className="members-mobile-label">LAST ACTIVE</span>
                    <b>{formatIst(lastActiveTime)}</b>
                    <small>{timeAgo(lastActiveTime)}</small>
                  </div>
                </div>
              </div>
            );
          })
        ) : (
          <div className="admin-empty">
            <b>No members matched your search or filters</b>
            <p>Try clearing your search query or switching filters.</p>
          </div>
        )}
      </div>

      {/* Member Activity Detail Modal (Requirement 11) */}
      {selectedMember && (
        <div className="member-detail-backdrop" role="presentation" onClick={() => setSelectedMember(null)}>
          <div
            className="member-detail-card"
            role="dialog"
            aria-modal="true"
            aria-labelledby="member-detail-name"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="member-detail-head">
              <div className="member-detail-profile">
                <span className={`members-avatar large ${selectedMember.role.toLowerCase().includes("admin") ? "avatar-admin" : ""}`}>
                  {initials(selectedMember.name)}
                </span>
                <div>
                  <h2 id="member-detail-name">{selectedMember.name}</h2>
                  <p>{selectedMember.email}</p>
                </div>
              </div>
              <button
                type="button"
                className="member-detail-close"
                onClick={() => setSelectedMember(null)}
                aria-label="Close activity detail"
              >
                ×
              </button>
            </div>

            {/* Key Usage Metrics */}
            <div className="member-detail-stats">
              <div className="member-stat-box">
                <span>TOTAL STUDY TIME</span>
                <b>{formatStudyTime(selectedMember.total_study_seconds)}</b>
                <small>Confirmed active time</small>
              </div>
              <div className="member-stat-box">
                <span>TOTAL SESSIONS</span>
                <b>{selectedMember.session_count ?? 0}</b>
                <small>Recorded study visits</small>
              </div>
              <div className="member-stat-box">
                <span>AVG. SESSION</span>
                <b>
                  {selectedMember.session_count && Number(selectedMember.session_count) > 0
                    ? formatStudyTime(Math.round(Number(selectedMember.total_study_seconds || 0) / Number(selectedMember.session_count)))
                    : "0m"}
                </b>
                <small>Per active session</small>
              </div>
              <div className="member-stat-box">
                <span>LAST CONFIRMED ACTIVE</span>
                <b>{timeAgo(selectedMember.last_seen || selectedMember.created_at)}</b>
                <small>{formatIst(selectedMember.last_seen || selectedMember.created_at)}</small>
              </div>
            </div>

            {/* Recent Sessions List */}
            <div className="member-sessions-section">
              <div className="member-sessions-header">
                <h3>Recent Study Sessions</h3>
                <span>{recentSessions.length} recorded</span>
              </div>

              {sessionsLoading ? (
                <div className="member-sessions-loading">Loading activity history…</div>
              ) : recentSessions.length > 0 ? (
                <div className="member-sessions-list">
                  {recentSessions.map((session) => {
                    const sessionDate = formatIst(session.started_at);
                    const startTime = formatSessionTime(session.started_at);
                    const endTime = formatSessionTime(session.last_heartbeat_at || session.ended_at);

                    return (
                      <div className="member-session-item" key={session.id}>
                        <div className="member-session-icon" aria-hidden="true">
                          {session.is_active ? "●" : "✓"}
                        </div>
                        <div className="member-session-info">
                          <div className="member-session-time">
                            <b>{sessionDate.split(",")[0]}</b>
                            <span>{startTime} → {endTime}</span>
                          </div>
                          <div className="member-session-page">
                            {session.resource_type ? (
                              <span className="session-resource-tag">{session.resource_type}</span>
                            ) : null}
                            <code>{session.page_path || "/"}</code>
                          </div>
                        </div>
                        <div className="member-session-duration">
                          <b>{formatStudyTime(session.duration_seconds)}</b>
                          {session.is_active ? <span className="session-active-pill">ACTIVE</span> : null}
                        </div>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <div className="member-sessions-empty">
                  No recorded study sessions for this member yet.
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
}
