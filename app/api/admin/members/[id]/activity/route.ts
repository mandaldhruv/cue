import { NextRequest, NextResponse } from "next/server";
import { requireAdminSession } from "../../../../../lib/supabase/server";

export const dynamic = "force-dynamic";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    await requireAdminSession();
    const resolvedParams = await params;
    const memberId = resolvedParams.id;

    if (!memberId) {
      return NextResponse.json({ ok: false, error: "Member ID required" }, { status: 400 });
    }

    // get_cue_member_sessions: student study session tracking is permanently removed.
    // Return empty session roster for admin UI compatibility.
    return NextResponse.json(
      { ok: true, sessions: [] },
      { headers: { "Cache-Control": "private, no-store, max-age=0" } }
    );
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Failed to load member activity";
    return NextResponse.json(
      { ok: false, error: message },
      { status: 403 }
    );
  }
}
