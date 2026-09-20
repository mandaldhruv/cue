import { NextResponse } from "next/server";
import { createInsForgeServerClient } from "../../../lib/insforge/server";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    const client = await createInsForgeServerClient();
    const { data, error } = await client.auth.getCurrentUser();
    const user = error ? null : data?.user ?? null;
    return NextResponse.json(
      { user },
      { headers: { "Cache-Control": "private, no-store, max-age=0" } },
    );
  } catch {
    return NextResponse.json(
      { user: null },
      { headers: { "Cache-Control": "private, no-store, max-age=0" } },
    );
  }
}
