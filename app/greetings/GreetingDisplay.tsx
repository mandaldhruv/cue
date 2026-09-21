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

function useGreeting(audience: Audience) {
  const { user, loading } = useAuth();
  const [greeting, setGreeting] = useState<GreetingState | null>(null);
  const [eventId] = useState(() => typeof crypto === "undefined" ? "" : crypto.randomUUID());

  useEffect(() => {
    if (loading || !user || !eventId) return;

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
  }, [audience, eventId, loading, user]);

  const message = user && greeting?.userId === user.id ? greeting.message : null;
  const timeBlock = user && greeting?.userId === user.id ? greeting.timeBlock : null;
  return { message, timeBlock, visible: !loading && Boolean(user) };
}

export function HomeGreeting() {
  const { message, timeBlock, visible } = useGreeting("student");
  if (!visible || !message) return null;

  return <section className="home-greeting" aria-label="Your Cue greeting">
    <div className="container home-greeting-inner">
      <span>{getSalutation(timeBlock, message)}</span>
      <h2>{message}</h2>
    </div>
  </section>;
}

export function AdminGreeting({ fallback }: { fallback: string }) {
  const { message, timeBlock } = useGreeting("admin");
  return <span className="admin-greeting-copy">
    {message ? <small>{getSalutation(timeBlock, message)}</small> : null}
    <strong>{message ?? fallback}</strong>
  </span>;
}
