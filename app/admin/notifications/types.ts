export type AdminNotificationType =
  | "new_member"
  | "new_feedback"
  | "content_issue"
  | "testimonial_published"
  | "pyq_updated"
  | "content_updated";

export type AdminNotificationCategory = "members" | "feedback" | "pyqs" | "content";

export type AdminNotificationPriority = "normal" | "high";

export interface AdminNotification {
  id: string;
  type: AdminNotificationType;
  title: string;
  message: string;
  category: AdminNotificationCategory;
  priority: AdminNotificationPriority;
  link: string;
  related_id: string | null;
  is_read: boolean;
  read_at: string | null;
  created_at: string;
}

export interface AdminNotificationCounts {
  total: number;
  members: number;
  feedback: number;
  content: number;
  pyqs: number;
}
