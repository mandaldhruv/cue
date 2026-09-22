"use client";

import { useEffect, useState } from "react";
import { useAuth } from "../auth/AuthProvider";

type Audience = "admin" | "student";

type GreetingState = {
  userId: string;
  message: string;
  timeBlock: number;
};

function getSalutation(timeBlock: number | null, message: string | null) {
  const salutation = timeBlock === 1
    ? "Late night,"
    : timeBlock === 2
      ? "Early start,"
      : timeBlock && timeBlock <= 4
        ? "Good morning,"
        : timeBlock && timeBlock <= 6
          ? "Good afternoon,"
          : "Good evening,";

  const normalizedMessage = message?.trim().toLowerCase() ?? "";
  const normalizedSalutation = salutation.replace(",", "").toLowerCase();
  return normalizedMessage.startsWith(normalizedSalutation) ? "Welcome back," : salutation;
}

function useGreeting(audience: Audience, initialGreeting: GreetingState | null = null) {
  const { user, loading } = useAuth();
  const [greeting, setGreeting] = useState<GreetingState | null>(initialGreeting);
  const [eventId] = useState(() => typeof crypto === "undefined" ? "" : crypto.randomUUID());

  useEffect(() => {
    if (loading || !user || !eventId || greeting?.userId === user.id) return;

    const controller = new AbortController();
    void fetch("/api/greetings", {
      method: "POST",
      credentials: "include",
      cache: "no-store",
      headers: { "Content-Type": "application/json", Accept: "application/json" },
      body: JSON.stringify({ audience, eventId }),
      signal: controller.signal,
    }).then(async (response) => {
      if (response.status === 204 || response.status === 401) return null;
      if (!response.ok) throw new Error("Greeting unavailable");
      return response.json() as Promise<{ message?: string; timeBlock?: number }>;
    }).then((data) => {
      if (data?.message) {
        setGreeting({
          userId: user.id,
          message: data.message,
          timeBlock: data.timeBlock ?? 7,
        });
      }
    }).catch((error: unknown) => {
      if (error instanceof DOMException && error.name === "AbortError") return;
    });

    return () => controller.abort();
  }, [audience, eventId, greeting?.userId, loading, user]);

  const message = user && greeting?.userId === user.id ? greeting.message : null;
  const timeBlock = user && greeting?.userId === user.id ? greeting.timeBlock : null;
  return { message, timeBlock, user, loading, visible: !loading && Boolean(user) };
}

function firstName(name: string | null | undefined) {
  const value = name?.trim();
  if (!value) return "Cue learner";
  const givenName = value.split(/\s+/u)[0];
  return givenName.charAt(0).toUpperCase() + givenName.slice(1);
}

export function HomeHeroHeading({
  initialUserId,
  initialName,
  initialMessage,
  initialTimeBlock,
}: {
  initialUserId?: string | null;
  initialName?: string | null;
  initialMessage?: string | null;
  initialTimeBlock?: number | null;
}) {
  const initialGreeting = initialUserId && initialMessage
    ? { userId: initialUserId, message: initialMessage, timeBlock: initialTimeBlock ?? 7 }
    : null;
  const { message, user, loading } = useGreeting("student", initialGreeting);
  const signedInName = loading
    ? initialName
    : user
      ? firstName(user.profile?.name || user.email.split("@")[0])
      : null;

  if (!signedInName && !loading) {
    return <h1>Your complete<br /><em>BMS study space.</em></h1>;
  }

  if (!signedInName) {
    return <h1>Your complete<br /><em>BMS study space.</em></h1>;
  }

  if (!message) {
    return <h1 className="hero-greeting-title hero-greeting-pending" aria-label={`Loading a greeting for ${firstName(signedInName)}`}><span /></h1>;
  }

  return <h1 className="hero-greeting-title" aria-live="polite">{message}</h1>;
}

export function AdminGreeting({ fallback }: { fallback: string }) {
  const { message, timeBlock } = useGreeting("admin");
  return <span className="admin-greeting-copy">
    {message ? <small>{getSalutation(timeBlock, message)}</small> : null}
    <strong>{message ?? fallback}</strong>
  </span>;
}
