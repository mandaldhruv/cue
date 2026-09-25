"use server";

import { revalidatePath } from "next/cache";
import { getAdminSession } from "../../lib/insforge/server";
import type {
  AdminNotification,
  AdminNotificationCategory,
  AdminNotificationCounts,
  AdminNotificationPriority,
  AdminNotificationType,
} from "./types";

async function adminContext() {
  const session = await getAdminSession();
  if (!session.user || !session.isAdmin) return null;
  return session;
}

export async function getAdminNotificationDataAction(): Promise<{
  counts: AdminNotificationCounts;
  notifications: AdminNotification[];
} | null> {
  const session = await adminContext();
  if (!session) return null;

  const [countsResult, listResult] = await Promise.all([
    session.client.database.rpc("get_admin_notification_counts"),
    session.client.database.rpc("get_admin_notifications", { p_limit: 50 }),
  ]);

  const rawCounts = (countsResult.data as Record<string, number> | null) ?? {};
  const counts: AdminNotificationCounts = {
    total: rawCounts.total ?? 0,
    members: rawCounts.members ?? 0,
    feedback: rawCounts.feedback ?? 0,
    content: rawCounts.content ?? 0,
    pyqs: rawCounts.pyqs ?? 0,
  };

  const notifications = (listResult.data as AdminNotification[] | null) ?? [];

  return { counts, notifications };
}

export async function markNotificationReadAction(id: string): Promise<boolean> {
  const session = await adminContext();
  if (!session || !id) return false;

  const { error } = await session.client.database.rpc("mark_admin_notification_read", {
    p_id: id,
  });

  if (error) {
    console.error("Failed to mark notification as read", error);
    return false;
  }

  revalidatePath("/admin");
  return true;
}

export async function markAllNotificationsReadAction(): Promise<boolean> {
  const session = await adminContext();
  if (!session) return false;

  const { error } = await session.client.database.rpc("mark_all_admin_notifications_read");

  if (error) {
    console.error("Failed to mark all notifications as read", error);
    return false;
  }

  revalidatePath("/admin");
  return true;
}

export async function markCategoryNotificationsReadAction(
  category: AdminNotificationCategory
): Promise<boolean> {
  const session = await adminContext();
  if (!session || !category) return false;

  const { error } = await session.client.database.rpc(
    "mark_category_admin_notifications_read",
    { p_category: category }
  );

  if (error) {
    console.error(`Failed to mark category '${category}' notifications as read`, error);
    return false;
  }

  revalidatePath("/admin");
  return true;
}

export async function recordAdminNotification(params: {
  type: AdminNotificationType;
  title: string;
  message: string;
  category: AdminNotificationCategory;
  priority?: AdminNotificationPriority;
  link?: string;
  relatedId?: string | null;
}): Promise<string | null> {
  const session = await adminContext();
  if (!session) return null;

  const { data, error } = await session.client.database.rpc("record_admin_notification", {
    p_type: params.type,
    p_title: params.title,
    p_message: params.message,
    p_category: params.category,
    p_priority: params.priority || "normal",
    p_link: params.link || "/admin",
    p_related_id: params.relatedId || null,
  });

  if (error) {
    console.error("Failed to record admin notification", error);
    return null;
  }

  revalidatePath("/admin");
  return (data as string) || null;
}
