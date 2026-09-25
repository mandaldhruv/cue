"use client";

import React, { createContext, useContext, useState, useEffect, useCallback, useTransition } from "react";
import type {
  AdminNotification,
  AdminNotificationCategory,
  AdminNotificationCounts,
} from "./types";
import {
  markNotificationReadAction,
  markAllNotificationsReadAction,
  markCategoryNotificationsReadAction,
} from "./actions";

interface AdminNotificationContextValue {
  counts: AdminNotificationCounts;
  notifications: AdminNotification[];
  markRead: (id: string) => Promise<void>;
  markAllRead: () => Promise<void>;
  markCategoryRead: (category: AdminNotificationCategory) => Promise<void>;
  refresh: () => Promise<void>;
}

const AdminNotificationContext = createContext<AdminNotificationContextValue | null>(null);

function routeToCategory(route: string): AdminNotificationCategory | null {
  if (route.startsWith("/admin/members")) return "members";
  if (route.startsWith("/admin/feedback")) return "feedback";
  if (route.startsWith("/admin/pyqs")) return "pyqs";
  if (route.startsWith("/admin/syllabus") || route.startsWith("/admin/flashcards") || route.startsWith("/admin/content")) {
    return "content";
  }
  return null;
}

export function AdminNotificationProvider({
  initialCounts,
  initialNotifications,
  activeRoute,
  children,
}: {
  initialCounts: AdminNotificationCounts;
  initialNotifications: AdminNotification[];
  activeRoute: string;
  children: React.ReactNode;
}) {
  const [counts, setCounts] = useState<AdminNotificationCounts>(initialCounts);
  const [notifications, setNotifications] = useState<AdminNotification[]>(initialNotifications);
  const [, startTransition] = useTransition();

  const refresh = useCallback(async () => {
    try {
      const res = await fetch("/api/admin/notifications", { credentials: "same-origin" });
      if (res.ok) {
        const data = await res.json();
        if (data.counts && Array.isArray(data.notifications)) {
          setCounts(data.counts);
          setNotifications(data.notifications);
        }
      }
    } catch {
      // Silently fall back to existing state on network hiccup
    }
  }, []);

  const markRead = useCallback(async (id: string) => {
    // Optimistic update
    setNotifications((prev) => {
      const target = prev.find((n) => n.id === id);
      if (!target || target.is_read) return prev;

      setCounts((prevCounts) => ({
        ...prevCounts,
        total: Math.max(0, prevCounts.total - 1),
        [target.category]: Math.max(0, (prevCounts[target.category] || 0) - 1),
      }));

      return prev.map((n) =>
        n.id === id ? { ...n, is_read: true, read_at: new Date().toISOString() } : n
      );
    });

    startTransition(async () => {
      await markNotificationReadAction(id);
    });
  }, []);

  const markAllRead = useCallback(async () => {
    setNotifications((prev) =>
      prev.map((n) => ({ ...n, is_read: true, read_at: n.read_at || new Date().toISOString() }))
    );
    setCounts({ total: 0, members: 0, feedback: 0, content: 0, pyqs: 0 });

    startTransition(async () => {
      await markAllNotificationsReadAction();
    });
  }, []);

  const markCategoryRead = useCallback(async (category: AdminNotificationCategory) => {
    setNotifications((prev) =>
      prev.map((n) =>
        n.category === category
          ? { ...n, is_read: true, read_at: n.read_at || new Date().toISOString() }
          : n
      )
    );

    setCounts((prevCounts) => {
      const categoryCount = prevCounts[category] || 0;
      return {
        ...prevCounts,
        total: Math.max(0, prevCounts.total - categoryCount),
        [category]: 0,
      };
    });

    startTransition(async () => {
      await markCategoryNotificationsReadAction(category);
    });
  }, []);

  // When visiting a category section, auto-mark that category's unread notifications as read
  useEffect(() => {
    const category = routeToCategory(activeRoute);
    if (category && counts[category] > 0) {
      markCategoryRead(category);
    }
  }, [activeRoute, counts, markCategoryRead]);

  // Periodic subtle background sync (every 30 seconds and on window focus)
  useEffect(() => {
    const interval = setInterval(refresh, 30000);
    const onFocus = () => {
      refresh();
    };
    window.addEventListener("focus", onFocus);
    return () => {
      clearInterval(interval);
      window.removeEventListener("focus", onFocus);
    };
  }, [refresh]);

  return (
    <AdminNotificationContext.Provider
      value={{
        counts,
        notifications,
        markRead,
        markAllRead,
        markCategoryRead,
        refresh,
      }}
    >
      {children}
    </AdminNotificationContext.Provider>
  );
}

export function useAdminNotifications() {
  const context = useContext(AdminNotificationContext);
  if (!context) {
    throw new Error("useAdminNotifications must be used within an AdminNotificationProvider");
  }
  return context;
}
