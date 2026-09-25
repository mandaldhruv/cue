import { NextRequest, NextResponse } from "next/server";
import greetingMessages from "../../greetings/greeting-messages.generated.json";
import { createInsForgeServerClient, isAuthorizedAdminEmail } from "../../lib/insforge/server";

export const dynamic = "force-dynamic";

type Audience = "admin" | "student";
type GreetingReservation = { time_block: number; message_index: number };

const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/iu;

function studentFirstName(user: { email?: string | null; profile?: { name?: string } | null }) {
  const profileName = user.profile?.name?.trim();
  if (profileName) return profileName.split(/\s+/u)[0];
  const emailName = user.email?.split("@")[0]?.replace(/[._-]+/gu, " ").trim();
  if (!emailName) return "Cue learner";
  return emailName.charAt(0).toUpperCase() + emailName.slice(1).split(/\s+/u)[0];
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json() as { audience?: Audience; eventId?: string };
    const audience = body.audience;
    const eventId = body.eventId;

    if ((audience !== "admin" && audience !== "student") || !eventId || !uuidPattern.test(eventId)) {
      return NextResponse.json({ message: "Invalid greeting request." }, { status: 400 });
    }

    const client = await createInsForgeServerClient();
    const { data: userData, error: userError } = await client.auth.getCurrentUser();
    const user = userError ? null : userData?.user ?? null;
    if (!user) return new NextResponse(null, { status: 401 });

    if (audience === "admin") {
      const email = (user.email ?? "").trim().toLowerCase();
      if (!isAuthorizedAdminEmail(email)) {
        return NextResponse.json({ message: "Forbidden: Admin access required." }, { status: 403 });
      }
    }

    const { data, error } = await client.database.rpc("reserve_cue_greeting", {
      p_audience: audience,
      p_event_id: eventId,
    });

    if (error) {
      console.error("Greeting reservation failed", { code: error.code });
      return NextResponse.json({ message: "Greeting is temporarily unavailable." }, { status: 503 });
    }

    const reservation = (Array.isArray(data) ? data[0] : data) as GreetingReservation | null;
    const blockIndex = Number(reservation?.time_block) - 1;
    const messageIndex = Number(reservation?.message_index);
    const source = greetingMessages[audience] as string[][];
    const sourceMessage = source[blockIndex]?.[messageIndex];

    if (!sourceMessage) {
      console.error("Greeting message lookup failed", { audience, blockIndex, messageIndex });
      return NextResponse.json({ message: "Greeting is temporarily unavailable." }, { status: 503 });
    }

    const message = audience === "student"
      ? sourceMessage.replaceAll("[Name]", studentFirstName(user))
      : sourceMessage;

    return NextResponse.json(
      { message, timeBlock: blockIndex + 1, position: messageIndex + 1 },
      { headers: { "Cache-Control": "private, no-store, max-age=0" } },
    );
  } catch {
    return NextResponse.json({ message: "Greeting is temporarily unavailable." }, { status: 503 });
  }
}
