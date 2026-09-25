import { NextRequest, NextResponse } from "next/server";
import { getAdminSession } from "../../../lib/insforge/server";
import type { AdminNotificationCategory } from "../../../admin/notifications/types";

export const dynamic = "force-dynamic";

export async function GET() {
  const session = await getAdminSession();
  if (!session.user || !session.isAdmin) {
    return NextResponse.json({ error: "Unauthorized access" }, { status: 401 });
  }

  const [countsResult, listResult] = await Promise.all([
    session.client.database.rpc("get_admin_notification_counts"),
    session.client.database.rpc("get_admin_notifications", { p_limit: 50 }),
  ]);

  if (countsResult.error || listResult.error) {
    return NextResponse.json(
      { error: "Could not fetch notification data" },
      { status: 500 }
    );
  }

  const rawCounts = (countsResult.data as Record<string, number> | null) ?? {};
  return NextResponse.json({
    counts: {
      total: rawCounts.total ?? 0,
      members: rawCounts.members ?? 0,
      feedback: rawCounts.feedback ?? 0,
      content: rawCounts.content ?? 0,
      pyqs: rawCounts.pyqs ?? 0,
    },
    notifications: listResult.data ?? [],
  });
}

export async function POST(request: NextRequest) {
  const session = await getAdminSession();
  if (!session.user || !session.isAdmin) {
    return NextResponse.json({ error: "Unauthorized access" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const action = String(body.action || "").trim();

    if (action === "mark_read") {
      const id = String(body.id || "").trim();
      if (!id) {
        return NextResponse.json({ error: "Missing notification id" }, { status: 400 });
      }
      const { error } = await session.client.database.rpc(
        "mark_admin_notification_read",
        { p_id: id }
      );
      if (error) {
        return NextResponse.json({ error: error.message }, { status: 500 });
      }
      return NextResponse.json({ ok: true });
    }

    if (action === "mark_all_read") {
      const { error } = await session.client.database.rpc(
        "mark_all_admin_notifications_read"
      );
      if (error) {
        return NextResponse.json({ error: error.message }, { status: 500 });
      }
      return NextResponse.json({ ok: true });
    }

    if (action === "mark_category_read") {
      const category = String(body.category || "").trim() as AdminNotificationCategory;
      if (!category) {
        return NextResponse.json({ error: "Missing category" }, { status: 400 });
      }
      const { error } = await session.client.database.rpc(
        "mark_category_admin_notifications_read",
        { p_category: category }
      );
      if (error) {
        return NextResponse.json({ error: error.message }, { status: 500 });
      }
      return NextResponse.json({ ok: true });
    }

    return NextResponse.json({ error: "Invalid action" }, { status: 400 });
  } catch {
    return NextResponse.json({ error: "Invalid request payload" }, { status: 400 });
  }
}
