"use client";

import React from "react";
import Link from "next/link";

export interface NavGroup {
  label: string;
  items: Array<[href: string, icon: string, label: string]>;
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
          {group.items.map(([href, icon, label]) => {
            const isActive = active === href;
            return (
              <Link
                key={href}
                className={`admin-nav-link ${isActive ? "active" : ""}`}
                href={href}
                onClick={onNavigate}
              >
                <span className="admin-nav-icon">{icon}</span>
                <span className="admin-sidebar-label">{label}</span>
              </Link>
            );
          })}
        </section>
      ))}
    </nav>
  );
}
