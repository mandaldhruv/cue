import { NextResponse } from "next/server";
import { requireAdminSession } from "../../../../lib/insforge/server";
import type { StudyTimeSummary } from "../../../../admin/types";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    const { client } = await requireAdminSession();

    const { data, error } = await client.database.rpc("get_cue_study_time_summary");
    if (error) {
      return NextResponse.json({ ok: false, error: error.message }, { status: 500 });
    }

    const row = Array.isArray(data) ? data[0] : data;
    const summary: StudyTimeSummary = {
      today_seconds: Number(row?.today_seconds || 0),
      week_seconds: Number(row?.week_seconds || 0),
      month_seconds: Number(row?.month_seconds || 0),
      all_time_seconds: Number(row?.all_time_seconds || 0),
    };

    return NextResponse.json(
      { ok: true, summary },
      { headers: { "Cache-Control": "private, no-store, max-age=0" } }
    );
  } catch (err: any) {
    return NextResponse.json(
      { ok: false, error: err?.message || "Failed to load study time summary" },
      { status: 403 }
    );
  }
}
