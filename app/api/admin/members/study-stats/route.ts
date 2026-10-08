import { NextResponse } from "next/server";
import { requireAdminSession } from "../../../../lib/supabase/server";
import type { StudyTimeSummary } from "../../../../admin/types";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    await requireAdminSession();

    // get_cue_study_time_summary: study-time telemetry is permanently removed.
    // Return deterministic zero summary for admin UI compatibility.
    const summary: StudyTimeSummary = {
      today_seconds: 0,
      week_seconds: 0,
      month_seconds: 0,
      all_time_seconds: 0,
    };

    return NextResponse.json(
      { ok: true, summary },
      { headers: { "Cache-Control": "private, no-store, max-age=0" } }
    );
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Failed to load study time summary";
    return NextResponse.json(
      { ok: false, error: message },
      { status: 403 }
    );
  }
}
