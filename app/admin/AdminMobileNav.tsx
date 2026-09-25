"use client";

import React, { useState, useEffect } from "react";
import { Logo } from "../components";
import { AdminSidebarNav, type NavGroup } from "./notifications/AdminSidebarNav";

export function AdminMobileNav({
  email,
  active,
  groups,
  signOutAction,
}: {
  email: string;
  active: string;
  groups: NavGroup[];
  signOutAction: () => Promise<void>;
}) {
  const [isOpen, setIsOpen] = useState(false);

  // Prevent background scrolling while drawer is open
  useEffect(() => {
    if (isOpen) {
      const originalOverflow = document.body.style.overflow;
      document.body.style.overflow = "hidden";

      const handleKeyDown = (e: KeyboardEvent) => {
        if (e.key === "Escape") {
          setIsOpen(false);
        }
      };

      window.addEventListener("keydown", handleKeyDown);
      return () => {
        document.body.style.overflow = originalOverflow;
        window.removeEventListener("keydown", handleKeyDown);
      };
    }
  }, [isOpen]);

  const closeDrawer = () => setIsOpen(false);

  return (
    <>
      <button
        type="button"
        className="admin-mobile-hamburger"
        onClick={() => setIsOpen((prev) => !prev)}
        aria-label="Open admin navigation menu"
        aria-expanded={isOpen}
      >
        <svg
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2.2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <line x1="3" y1="6" x2="21" y2="6" />
          <line x1="3" y1="12" x2="21" y2="12" />
          <line x1="3" y1="18" x2="21" y2="18" />
        </svg>
      </button>

      {/* Backdrop overlay */}
      {isOpen && (
        <div
          className="admin-drawer-backdrop"
          onClick={closeDrawer}
          aria-hidden="true"
        />
      )}

      {/* Slide-out drawer from the left */}
      <aside
        className={`admin-mobile-drawer ${isOpen ? "open" : ""}`}
        role="dialog"
        aria-modal="true"
        aria-label="Admin Navigation Drawer"
      >
        <div className="admin-drawer-head">
          <Logo />
          <button
            type="button"
            className="admin-drawer-close"
            onClick={closeDrawer}
            aria-label="Close navigation menu"
          >
            <svg
              width="18"
              height="18"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2.2"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        </div>

        <div className="admin-drawer-scroll">
          <AdminSidebarNav groups={groups} active={active} onNavigate={closeDrawer} />
          <div className="admin-drawer-foot">
            <small>SIGNED IN AS</small>
            <b>{email}</b>
            <form action={signOutAction}>
              <button type="submit">Sign out</button>
            </form>
          </div>
        </div>
      </aside>
    </>
  );
}
