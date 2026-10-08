import { createServerClient } from "@supabase/ssr";
import { NextRequest, NextResponse } from "next/server";
import { notifyAdminNewMember } from "../../../lib/email/admin-notifications";

function safeNext(value?: string | null) {
  return value && value.startsWith("/") && !value.startsWith("//") ? value : "/";
}

export async function GET(request: NextRequest) {
  const code = request.nextUrl.searchParams.get("code");
  const next = safeNext(
    request.nextUrl.searchParams.get("next") ||
    request.cookies.get("cue_auth_return")?.value
  );
  const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL || request.nextUrl.origin).replace(/\/$/, "");
  const redirectUrl = new URL(next, siteUrl);
  const errorRedirect = new URL(`/login?error=google&next=${encodeURIComponent(next)}`, siteUrl);

  if (!code) {
    return NextResponse.redirect(errorRedirect);
  }

  const response = NextResponse.redirect(redirectUrl);

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !supabaseAnonKey) {
    return NextResponse.redirect(errorRedirect);
  }

  const supabase = createServerClient(supabaseUrl, supabaseAnonKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll();
      },
      setAll(cookiesToSet) {
        cookiesToSet.forEach(({ name, value, options }) => {
          request.cookies.set(name, value);
          response.cookies.set(name, value, options);
        });
      },
    },
  });

  const { data, error } = await supabase.auth.exchangeCodeForSession(code);
  if (error || !data?.user) {
    return NextResponse.redirect(errorRedirect);
  }

  response.cookies.delete("cue_auth_return");

  const email = data.user.email || "";
  const name =
    (data.user.user_metadata?.name as string | undefined) ||
    (data.user.user_metadata?.full_name as string | undefined) ||
    email.split("@")[0] ||
    "Student";

  void notifyAdminNewMember({
    userId: data.user.id,
    name,
    email,
    role: "Student",
    status: "Verified",
    joinedAt: new Date(),
  });

  return response;
}
