import { NextRequest, NextResponse } from "next/server";
import { createInsForgeServerClient } from "../../../lib/insforge/server";

export const dynamic = "force-dynamic";

export async function POST(request: NextRequest) {
  try {
    const client = await createInsForgeServerClient();
    const { data: authData, error: authError } = await client.auth.getCurrentUser();
    const user = authData?.user ?? null;

    if (authError || !user) {
      return NextResponse.json(
        { ok: false, error: "Authentication required to record study heartbeat" },
        { status: 401, headers: { "Cache-Control": "private, no-store, max-age=0" } }
      );
    }

    let payload: Record<string, any> = {};
    const contentType = request.headers.get("content-type") || "";

    if (contentType.includes("application/json")) {
      payload = await request.json().catch(() => ({}));
    } else {
      const text = await request.text().catch(() => "");
      try {
        payload = text ? JSON.parse(text) : {};
      } catch {
        payload = {};
      }
    }

    const sessionToken = String(payload.sessionToken || payload.session_token || "").trim();
    if (!sessionToken) {
      return NextResponse.json(
        { ok: false, error: "sessionToken is required" },
        { status: 400, headers: { "Cache-Control": "private, no-store, max-age=0" } }
      );
    }

    const rawDelta = Number(payload.deltaSeconds ?? payload.delta_seconds ?? 0);
    const deltaSeconds = Math.max(0, Math.min(Math.round(isNaN(rawDelta) ? 0 : rawDelta), 120));
    const pagePath = String(payload.pagePath || payload.page_path || "/").slice(0, 500);
    const isClosing = Boolean(payload.isClosing ?? payload.is_closing ?? false);
    const resourceType = payload.resourceType ? String(payload.resourceType).slice(0, 50) : null;
    const resourceId = payload.resourceId ? String(payload.resourceId).slice(0, 100) : null;
    const metadata = typeof payload.metadata === "object" && payload.metadata !== null ? payload.metadata : {};

    const { data, error } = await client.database.rpc("record_cue_study_heartbeat", {
      p_session_token: sessionToken,
      p_delta_seconds: deltaSeconds,
      p_page_path: pagePath,
      p_is_closing: isClosing,
      p_resource_type: resourceType,
      p_resource_id: resourceId,
      p_metadata: metadata,
    });

    if (error) {
      return NextResponse.json(
        { ok: false, error: error.message },
        { status: 500, headers: { "Cache-Control": "private, no-store, max-age=0" } }
      );
    }

    return NextResponse.json(
      { ok: true, data },
      { headers: { "Cache-Control": "private, no-store, max-age=0" } }
    );
  } catch (err: any) {
    return NextResponse.json(
      { ok: false, error: err?.message || "Internal server error" },
      { status: 500, headers: { "Cache-Control": "private, no-store, max-age=0" } }
    );
  }
}
