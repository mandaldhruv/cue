import { NextResponse } from "next/server";
import { createServerClient } from "../../../lib/supabase/server";

export const dynamic = "force-dynamic";

export async function POST() {
  try {
    const supabase = await createServerClient();
    const { data, error } = await supabase.auth.getUser();
    if (error || !data?.user) {
      return NextResponse.json({ user: null }, { status: 401 });
    }
    return NextResponse.json({ user: data.user }, { status: 200 });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Refresh failed";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
