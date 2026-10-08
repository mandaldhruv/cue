import { NextResponse } from "next/server";
import { createServerClient } from "../../../lib/supabase/server";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    const client = await createServerClient();
    // Use client.auth.getUser() (aliased as client.auth.getCurrentUser() for backward compatibility)
    const { data, error } = await client.auth.getUser();
    const authUser = error ? null : data?.user ?? null;
    const user = authUser ? {
      id: authUser.id,
      email: authUser.email ?? "",
      profile: {
        name: (authUser.user_metadata?.name as string | undefined) ||
          (authUser.user_metadata?.full_name as string | undefined) ||
          authUser.email?.split("@")[0] ||
          "Student",
        avatar_url: authUser.user_metadata?.avatar_url as string | undefined,
      },
      ...authUser,
    } : null;
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
