"use client";

import React, { useState, useRef, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAdminNotifications } from "./AdminNotificationContext";
import type { AdminNotification, AdminNotificationType } from "./types";

function formatRelativeTime(dateString: string): string {
  try {
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    if (diffMs < 0) return "Just now";
    const diffSec = Math.floor(diffMs / 1000);
    const diffMin = Math.floor(diffSec / 60);
    const diffHour = Math.floor(diffMin / 60);
    const diffDay = Math.floor(diffHour / 24);

    if (diffMin < 1) return "Just now";
    if (diffMin < 60) return `${diffMin}m ago`;
    if (diffHour < 24) return `${diffHour}h ago`;
    if (diffDay === 1) return "Yesterday";
    if (diffDay < 7) return `${diffDay}d ago`;
    return date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
  } catch {
    return "Recently";
  }
}

function NotificationIcon({ type, priority }: { type: AdminNotificationType; priority?: string }) {
  if (type === "content_issue" || priority === "high") {
    return (
      <span className="admin-notif-item-icon priority-high" aria-hidden="true">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
          <line x1="12" y1="9" x2="12" y2="13"/>
          <line x1="12" y1="17" x2="12.01" y2="17"/>
        </svg>
      </span>
    );
  }

  if (type === "new_member") {
    return (
      <span className="admin-notif-item-icon type-member" aria-hidden="true">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
          <circle cx="12" cy="7" r="4"/>
        </svg>
      </span>
    );
  }

  if (type === "new_feedback") {
    return (
      <span className="admin-notif-item-icon type-feedback" aria-hidden="true">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
        </svg>
      </span>
    );
  }

  if (type === "testimonial_published") {
    return (
      <span className="admin-notif-item-icon type-testimonial" aria-hidden="true">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
        </svg>
      </span>
    );
  }

  if (type === "pyq_updated") {
    return (
      <span className="admin-notif-item-icon type-pyq" aria-hidden="true">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
          <line x1="16" y1="13" x2="8" y2="13"/>
          <line x1="16" y1="17" x2="8" y2="17"/>
          <polyline points="10 9 9 9 8 9"/>
        </svg>
      </span>
    );
  }

  // content_updated / fallback
  return (
    <span className="admin-notif-item-icon type-content" aria-hidden="true">
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
      </svg>
    </span>
  );
}

export default function AdminNotificationBell({ className = "" }: { className?: string }) {
  const { counts, notifications, markRead, markAllRead } = useAdminNotifications();
  const [isOpen, setIsOpen] = useState(false);
  const [filter, setFilter] = useState<"all" | "unread">("all");
  const panelRef = useRef<HTMLDivElement>(null);
  const buttonRef = useRef<HTMLButtonElement>(null);
  const router = useRouter();

  const unreadCount = counts.total;

  // Close when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (
        panelRef.current &&
        !panelRef.current.contains(event.target as Node) &&
        buttonRef.current &&
        !buttonRef.current.contains(event.target as Node)
      ) {
        setIsOpen(false);
      }
    }

    function handleKeyDown(event: KeyboardEvent) {
      if (event.key === "Escape") {
        setIsOpen(false);
      }
    }

    if (isOpen) {
      document.addEventListener("mousedown", handleClickOutside);
      document.addEventListener("keydown", handleKeyDown);
    }
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
      document.removeEventListener("keydown", handleKeyDown);
    };
  }, [isOpen]);

  const displayedNotifications = filter === "unread"
    ? notifications.filter((n) => !n.is_read)
    : notifications;

  const handleNotificationClick = async (notif: AdminNotification) => {
    if (!notif.is_read) {
      await markRead(notif.id);
    }
    setIsOpen(false);
    if (notif.link) {
      router.push(notif.link);
    }
  };

  return (
    <div className={`admin-notif-container ${className}`}>
      <button
        ref={buttonRef}
        type="button"
        className={`admin-notif-trigger ${isOpen ? "active" : ""} ${unreadCount > 0 ? "has-unread" : ""}`}
        onClick={() => setIsOpen((prev) => !prev)}
        aria-label={`Notifications${unreadCount > 0 ? ` (${unreadCount} unread)` : ""}`}
        aria-expanded={isOpen}
      >
        {/* Cue Notification Bell Icon */}
        <svg
          className="admin-notif-icon"
          width="19"
          height="19"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
          <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
        </svg>

        {/* Unread badge: NEVER show 0, hide completely when 0 */}
        {unreadCount > 0 && (
          <span className="admin-notif-badge" key={unreadCount}>
            {unreadCount > 99 ? "99+" : unreadCount}
          </span>
        )}
      </button>

      {isOpen && (
        <div ref={panelRef} className="admin-notif-panel" role="dialog" aria-label="Admin Notifications">
          <header className="admin-notif-header">
            <div className="admin-notif-header-title">
              <h3>Notifications</h3>
              {unreadCount > 0 && (
                <span className="admin-notif-count-pill">{unreadCount} new</span>
              )}
            </div>
            {unreadCount > 0 && (
              <button
                type="button"
                className="admin-notif-mark-all"
                onClick={async () => {
                  await markAllRead();
                }}
              >
                Mark all as read
              </button>
            )}
          </header>

          <div className="admin-notif-tabs">
            <button
              type="button"
              className={filter === "all" ? "active" : ""}
              onClick={() => setFilter("all")}
            >
              All {notifications.length > 0 && `(${notifications.length})`}
            </button>
            <button
              type="button"
              className={filter === "unread" ? "active" : ""}
              onClick={() => setFilter("unread")}
            >
              Unread {unreadCount > 0 && `(${unreadCount})`}
            </button>
          </div>

          <div className="admin-notif-list">
            {displayedNotifications.length === 0 ? (
              <div className="admin-notif-empty">
                <div className="admin-notif-empty-icon" aria-hidden="true">
                  <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                    <polyline points="22 4 12 14.01 9 11.01"/>
                  </svg>
                </div>
                <b>You&apos;re all caught up.</b>
                <p>No new notifications right now.</p>
              </div>
            ) : (
              displayedNotifications.map((notif) => (
                <button
                  key={notif.id}
                  type="button"
                  className={`admin-notif-item ${notif.is_read ? "is-read" : "is-unread"} ${notif.priority === "high" ? "priority-high" : ""}`}
                  onClick={() => handleNotificationClick(notif)}
                >
                  <NotificationIcon type={notif.type} priority={notif.priority} />
                  <div className="admin-notif-item-body">
                    <div className="admin-notif-item-head">
                      <strong className="admin-notif-item-title">{notif.title}</strong>
                      <span className="admin-notif-item-time">{formatRelativeTime(notif.created_at)}</span>
                    </div>
                    <p className="admin-notif-item-msg">{notif.message}</p>
                    <div className="admin-notif-item-meta">
                      <span className="admin-notif-item-category">
                        {notif.category === "members" && "Members & Users"}
                        {notif.category === "feedback" && (notif.type === "testimonial_published" ? "Testimonial" : "Feedback")}
                        {notif.category === "pyqs" && "PYQs & PDFs"}
                        {notif.category === "content" && "Study Content"}
                      </span>
                      {!notif.is_read && <span className="admin-notif-item-unread-dot" title="Unread" />}
                    </div>
                  </div>
                </button>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
