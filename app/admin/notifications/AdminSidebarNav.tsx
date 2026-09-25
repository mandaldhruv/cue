"use client";

import React from "react";
import Link from "next/link";
import { useAdminNotifications } from "./AdminNotificationContext";

export interface NavGroup {
  label: string;
  items: Array<[href: string, icon: string, label: string]>;
}

export function AdminSidebarNav({
  groups,
  active,
  isMobile = false,
}: {
  groups: NavGroup[];
  active: string;
  isMobile?: boolean;
}) {
  const { counts } = useAdminNotifications();

  const getCategoryCount = (href: string): number => {
    if (href === "/admin/members") return counts.members;
    if (href === "/admin/feedback") return counts.feedback;
    if (href === "/admin/pyqs") return counts.pyqs;
    if (href === "/admin/syllabus" || href === "/admin/flashcards") return counts.content;
    return 0;
  };

  return (
    <nav>
      {groups.map((group) => (
        <section key={group.label}>
          <small>{group.label}</small>
          {group.items.map(([href, icon, label]) => {
            const count = getCategoryCount(href);
            const isActive = active === href;

            if (isMobile) {
              return (
                <Link key={href} className={isActive ? "active" : ""} href={href}>
                  <span>{icon}</span>
                  <b>{label}</b>
                  {count > 0 && (
                    <span className="admin-sidebar-badge">{count > 99 ? "99+" : count}</span>
                  )}
                  <i>→</i>
                </Link>
              );
            }

            return (
              <Link key={href} className={isActive ? "active" : ""} href={href}>
                <span>{icon}</span>
                <span className="admin-sidebar-label">{label}</span>
                {count > 0 && (
                  <span className="admin-sidebar-badge">{count > 99 ? "99+" : count}</span>
                )}
              </Link>
            );
          })}
        </section>
      ))}
    </nav>
  );
}
