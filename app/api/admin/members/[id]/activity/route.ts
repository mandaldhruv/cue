import { NextRequest, NextResponse } from "next/server";
import { requireAdminSession } from "../../../../../lib/insforge/server";

export const dynamic = "force-dynamic";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { client } = await requireAdminSession();
    const resolvedParams = await params;
    const memberId = resolvedParams.id;

    if (!memberId) {
      return NextResponse.json({ ok: false, error: "Member ID required" }, { status: 400 });
    }

    const { data, error } = await client.database.rpc("get_cue_member_sessions", {
      p_user_id: memberId,
      p_limit: 20,
    });

    if (error) {
      return NextResponse.json({ ok: false, error: error.message }, { status: 500 });
    }

    return NextResponse.json(
      { ok: true, sessions: data ?? [] },
      { headers: { "Cache-Control": "private, no-store, max-age=0" } }
    );
  } catch (err: any) {
    return NextResponse.json(
      { ok: false, error: err?.message || "Failed to load member activity" },
      { status: 403 }
    );
  }
}
