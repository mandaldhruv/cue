"use client";

import React from "react";
import Link from "next/link";

export interface NavGroup {
  label: string;
  items: Array<[href: string, icon: string, label: string]>;
}

function NavIcon({ href }: { href: string }) {
  switch (href) {
    case "/admin":
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <rect x="3" y="3" width="7" height="9" rx="1.5" />
          <rect x="14" y="3" width="7" height="5" rx="1.5" />
          <rect x="14" y="12" width="7" height="9" rx="1.5" />
          <rect x="3" y="16" width="7" height="5" rx="1.5" />
        </svg>
      );
    case "/admin/semesters":
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <path d="m12 3-9 4.5 9 4.5 9-4.5L12 3Z" />
          <path d="m3 12 9 4.5 9-4.5" />
          <path d="m3 16.5 9 4.5 9-4.5" />
        </svg>
      );
    case "/admin/subjects":
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z" />
          <path d="M6 6h10" />
          <path d="M6 10h10" />
        </svg>
      );
    case "/admin/syllabus":
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
          <polyline points="14 2 14 8 20 8" />
          <line x1="16" y1="13" x2="8" y2="13" />
          <line x1="16" y1="17" x2="8" y2="17" />
          <line x1="10" y1="9" x2="8" y2="9" />
        </svg>
      );
    case "/admin/flashcards":
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <rect x="3" y="7" width="14" height="14" rx="2" />
          <path d="M7 3h12a2 2 0 0 1 2 2v12" />
          <path d="M7 11h6" />
        </svg>
      );
    case "/admin/pyqs":
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z" />
          <polyline points="14 2 14 8 20 8" />
          <path d="M12 18v-6" />
          <path d="m9 15 3 3 3-3" />
        </svg>
      );
    case "/admin/members":
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
          <circle cx="9" cy="7" r="4" />
          <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
          <path d="M16 3.13a4 4 0 0 1 0 7.75" />
        </svg>
      );
    case "/admin/feedback":
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
          <line x1="8" y1="10" x2="16" y2="10" />
          <line x1="8" y1="14" x2="13" y2="14" />
        </svg>
      );
    default:
      return (
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
          aria-hidden="true"
        >
          <circle cx="12" cy="12" r="9" />
          <path d="m9 12 2 2 4-4" />
        </svg>
      );
  }
}

export function AdminSidebarNav({
  groups,
  active,
  onNavigate,
}: {
  groups: NavGroup[];
  active: string;
  isMobile?: boolean;
  onNavigate?: () => void;
}) {
  return (
    <nav className="admin-sidebar-nav-tree">
      {groups.map((group) => (
        <section key={group.label} className="admin-nav-section">
          <small className="admin-nav-section-label">{group.label}</small>
          {group.items.map(([href, , label]) => {
            const isActive = active === href;
            return (
              <Link
                key={href}
                className={`admin-nav-link ${isActive ? "active" : ""}`}
                href={href}
                onClick={onNavigate}
              >
                <span className="admin-nav-icon">
                  <NavIcon href={href} />
                </span>
                <span className="admin-sidebar-label">{label}</span>
              </Link>
            );
          })}
        </section>
      ))}
    </nav>
  );
}
