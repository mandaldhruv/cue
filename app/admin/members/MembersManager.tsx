"use client";

import { useEffect, useMemo, useState } from "react";
import type { MemberRecord, StudyTimeSummary, UserSessionRecord } from "../types";

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

const IST_OFFSET_MS = 5.5 * 60 * 60 * 1000;

function isTodayIst(dateStr: string | null | undefined): boolean {
  if (!dateStr) return false;
  const d = new Date(dateStr);
  if (Number.isNaN(d.getTime())) return false;
  const now = new Date();

  const targetDay = Math.floor((d.getTime() + IST_OFFSET_MS) / 86400000);
  const currentDay = Math.floor((now.getTime() + IST_OFFSET_MS) / 86400000);
  return targetDay === currentDay;
}

function isThisWeekIst(dateStr: string | null | undefined): boolean {
  if (!dateStr) return false;
  const d = new Date(dateStr);
  if (Number.isNaN(d.getTime())) return false;
  const now = new Date();

  const targetDay = Math.floor((d.getTime() + IST_OFFSET_MS) / 86400000);
  const currentDay = Math.floor((now.getTime() + IST_OFFSET_MS) / 86400000);

  const currentDayOfWeek = (currentDay + 4) % 7; // 0=Sun, 1=Mon, ..., 6=Sat
  const diffToMonday = (currentDayOfWeek + 6) % 7;
  const weekStartDay = currentDay - diffToMonday;
  const nextWeekStartDay = weekStartDay + 7;

  return targetDay >= weekStartDay && targetDay < nextWeekStartDay;
}

function isInactive7Days(dateStr: string | null | undefined): boolean {
  if (!dateStr) return true;
  const d = new Date(dateStr);
  if (Number.isNaN(d.getTime())) return true;
  return Date.now() - d.getTime() >= 7 * 24 * 60 * 60 * 1000;
}

export default function MembersManager({
  members,
  initialStudyStats,
}: {
  members: MemberRecord[];
  initialStudyStats?: StudyTimeSummary;
}) {
  const [search, setSearch] = useState("");
  const [roleFilter, setRoleFilter] = useState<string>("student");
  const [activityFilter, setActivityFilter] = useState<"all" | "today" | "week" | "no_study_time" | "inactive">("all");
  const [sortKey, setSortKey] = useState<"newest" | "active" | "study_time" | "name" | "oldest">("active");

  // Selected member for detail modal
  const [selectedMember, setSelectedMember] = useState<MemberRecord | null>(null);
  const [sessionsLoading, setSessionsLoading] = useState(false);
  const [recentSessions, setRecentSessions] = useState<UserSessionRecord[]>([]);

  // Study time overview modal
  const [showStudyStatsModal, setShowStudyStatsModal] = useState(false);
  const [studyStats, setStudyStats] = useState<StudyTimeSummary>(() => {
    return initialStudyStats || {
      today_seconds: 0,
      week_seconds: 0,
      month_seconds: 0,
      all_time_seconds: 0,
    };
  });

  // Global keydown handler to close modals on Escape
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        setSelectedMember(null);
        setRecentSessions([]);
        setShowStudyStatsModal(false);
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, []);

  // Refresh study stats when modal opens
  useEffect(() => {
    if (!showStudyStatsModal) return;
    let isMounted = true;
    fetch("/api/admin/members/study-stats")
      .then((res) => (res.ok ? res.json() : null))
      .then((data) => {
        if (isMounted && data?.ok && data.summary) {
          setStudyStats(data.summary);
        }
      })
      .catch(() => {});
    return () => {
      isMounted = false;
    };
  }, [showStudyStatsModal]);

  // Load sessions when a member is selected
  useEffect(() => {
    if (!selectedMember) return;

    let isMounted = true;
    (async () => {
      try {
        setSessionsLoading(true);
        const res = await fetch(`/api/admin/members/${selectedMember.id}/activity`);
        if (!res.ok) throw new Error("Failed to load");
        const data = await res.json();
        if (isMounted) {
          setRecentSessions(data.sessions || []);
        }
      } catch {
        if (isMounted) setRecentSessions([]);
      } finally {
        if (isMounted) setSessionsLoading(false);
      }
    })();

    return () => {
      isMounted = false;
    };
  }, [selectedMember]);

  // Metrics
  const totalCount = members.length;
  const newTodayCount = useMemo(() => members.filter((m) => isWithinHours(m.created_at, 24)).length, [members]);
  const newThisWeekCount = useMemo(() => members.filter((m) => isWithinDays(m.created_at, 7)).length, [members]);
  const verifiedCount = useMemo(() => members.filter((m) => m.email_verified).length, [members]);
  const activeThisWeekCount = useMemo(() => {
    return members.filter((m) => isThisWeekIst(m.last_seen)).length;
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
        if (activityFilter === "today") {
          if (!member.last_seen || !isTodayIst(member.last_seen)) return false;
        }
        if (activityFilter === "week") {
          if (!member.last_seen || !isThisWeekIst(member.last_seen)) return false;
        }
        if (activityFilter === "no_study_time") {
          const seconds = Number(member.total_study_seconds || 0);
          if (seconds > 0) return false;
        }
        if (activityFilter === "inactive") {
          if (!isInactive7Days(member.last_seen)) return false;
        }
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
          const aTime = a.last_seen ? new Date(a.last_seen).getTime() : 0;
          const bTime = b.last_seen ? new Date(b.last_seen).getTime() : 0;
          if (bTime !== aTime) return bTime - aTime;
          return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
        }
        return 0;
      });
  }, [members, search, roleFilter, activityFilter, sortKey]);

  return (
    <>
      <section className="members-stat-grid" aria-label="Member metrics">
        <article className="members-stat-card">
          <div className="members-stat-top">
            <div className="members-stat-icon-wrap icon-blue" aria-hidden="true">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                <circle cx="9" cy="7" r="4" />
                <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
                <path d="M16 3.13a4 4 0 0 1 0 7.75" />
              </svg>
            </div>
          </div>
          <span>TOTAL MEMBERS</span>
          <b>{totalCount}</b>
          <p>{verifiedCount} verified accounts</p>
        </article>

        <article className="members-stat-card highlight">
          <div className="members-stat-top">
            <div className="members-stat-icon-wrap icon-green" aria-hidden="true">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                <circle cx="9" cy="7" r="4" />
                <line x1="19" y1="8" x2="19" y2="14" />
                <line x1="22" y1="11" x2="16" y2="11" />
              </svg>
            </div>
          </div>
          <span>NEW TODAY</span>
          <b>{newTodayCount}</b>
          <p>{newThisWeekCount} joined in last 7 days</p>
        </article>

        <article className="members-stat-card">
          <div className="members-stat-top">
            <div className="members-stat-icon-wrap icon-purple" aria-hidden="true">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
              </svg>
            </div>
          </div>
          <span>ACTIVE THIS WEEK</span>
          <b>{activeThisWeekCount}</b>
          <p>Confirmed student activity</p>
        </article>

        <article
          className="members-stat-card clickable"
          onClick={() => setShowStudyStatsModal(true)}
          role="button"
          tabIndex={0}
          onKeyDown={(e) => {
            if (e.key === "Enter" || e.key === " ") {
              e.preventDefault();
              setShowStudyStatsModal(true);
            }
          }}
          aria-label="View study time breakdown across all students"
          title="Click to view study time breakdown"
        >
          <div className="members-stat-top">
            <div className="members-stat-icon-wrap icon-amber" aria-hidden="true">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="12" cy="12" r="10" />
                <polyline points="12 6 12 12 16 14" />
              </svg>
            </div>
          </div>
          <span>STUDY TIME THIS WEEK</span>
          <b>{formatStudyTime(studyStats.week_seconds)}</b>
          <p>Across all students</p>
        </article>
      </section>

      <div className="members-toolbar">
        <div className="members-search-wrap">
          <span className="members-search-icon" aria-hidden="true">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
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
            <span>ACTIVITY</span>
            <select value={activityFilter} onChange={(e) => setActivityFilter(e.target.value as "all" | "today" | "week" | "no_study_time" | "inactive")}>
              <option value="all">All Activity</option>
              <option value="today">Active Today</option>
              <option value="week">Active This Week</option>
              <option value="no_study_time">No Study Time</option>
              <option value="inactive">Inactive</option>
            </select>
          </label>

          <label>
            <span>SORT</span>
            <select value={sortKey} onChange={(e) => setSortKey(e.target.value as "newest" | "active" | "study_time" | "name" | "oldest")}>
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
                    {isAdmin ? "Admin" : member.role}
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
          <div className="members-empty-state">
            <div className="members-empty-icon" aria-hidden="true">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="11" cy="11" r="8" />
                <line x1="21" y1="21" x2="16.65" y2="16.65" />
              </svg>
            </div>
            <b>No members found</b>
            <p>No student or administrator accounts match your current search query or filter selection.</p>
            {(search || roleFilter !== "all" || activityFilter !== "all") && (
              <button
                type="button"
                className="members-empty-reset"
                onClick={() => {
                  setSearch("");
                  setRoleFilter("all");
                  setActivityFilter("all");
                }}
              >
                Clear all filters
              </button>
            )}
          </div>
        )}
      </div>

      {/* Member Activity Detail Modal */}
      {selectedMember && (
        <div className="member-detail-backdrop" role="presentation" onClick={() => { setSelectedMember(null); setRecentSessions([]); }}>
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
                onClick={() => { setSelectedMember(null); setRecentSessions([]); }}
                aria-label="Close activity detail"
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <line x1="18" y1="6" x2="6" y2="18" />
                  <line x1="6" y1="6" x2="18" y2="18" />
                </svg>
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
                        <div className={`member-session-icon ${session.is_active ? "is-live" : ""}`} aria-hidden="true">
                          {session.is_active ? (
                            <span className="session-pulse-dot" />
                          ) : (
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                              <polyline points="20 6 9 17 4 12" />
                            </svg>
                          )}
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

      {/* Total Study Time Overview Modal */}
      {showStudyStatsModal && (
        <div
          className="member-detail-backdrop"
          role="presentation"
          onClick={() => setShowStudyStatsModal(false)}
        >
          <div
            className="study-summary-modal-card"
            role="dialog"
            aria-modal="true"
            aria-labelledby="study-summary-title"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="study-summary-modal-head">
              <div>
                <span className="study-summary-eyebrow">STUDY TIME</span>
                <p id="study-summary-title">Total tracked study activity across all students</p>
              </div>
              <button
                type="button"
                className="member-detail-close"
                onClick={() => setShowStudyStatsModal(false)}
                aria-label="Close study time dialog"
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <line x1="18" y1="6" x2="6" y2="18" />
                  <line x1="6" y1="6" x2="18" y2="18" />
                </svg>
              </button>
            </div>

            <div className="study-summary-grid">
              <div className="study-summary-metric-card">
                <span className="study-summary-metric-label">TODAY</span>
                <b className="study-summary-metric-value">{formatStudyTime(studyStats.today_seconds)}</b>
              </div>

              <div className="study-summary-metric-card highlight">
                <span className="study-summary-metric-label">THIS WEEK</span>
                <b className="study-summary-metric-value">{formatStudyTime(studyStats.week_seconds)}</b>
              </div>

              <div className="study-summary-metric-card">
                <span className="study-summary-metric-label">THIS MONTH</span>
                <b className="study-summary-metric-value">{formatStudyTime(studyStats.month_seconds)}</b>
              </div>

              <div className="study-summary-metric-card">
                <span className="study-summary-metric-label">ALL TIME</span>
                <b className="study-summary-metric-value">{formatStudyTime(studyStats.all_time_seconds)}</b>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
