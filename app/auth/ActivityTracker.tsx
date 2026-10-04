"use client";

import { useEffect, useRef } from "react";
import { usePathname } from "next/navigation";
import { useAuth } from "./AuthContext";
import { isAdminRoute } from "../lib/study-tracking";

const SESSION_STORAGE_KEY = "cue_active_session_v1";
const LOCAL_STORAGE_KEY = "cue_last_session_v1";
const INACTIVITY_THRESHOLD_MS = 120_000; // 2 minutes of idle time pauses active counting
const HEARTBEAT_INTERVAL_SECONDS = 25; // Send updates every 25 seconds of confirmed active study
const SESSION_TIMEOUT_MS = 15 * 60 * 1000; // 15 minutes of inactivity starts a new session

function isInAdminContext(currentPath: string): boolean {
  if (isAdminRoute(currentPath)) return true;
  if (typeof document !== "undefined" && Boolean(document.querySelector('[data-admin-context="true"]'))) {
    return true;
  }
  return false;
}

function getResourceType(pathname: string): string | null {
  if (isAdminRoute(pathname)) return "admin_panel";
  if (pathname.startsWith("/subjects/")) return "subject";
  if (pathname === "/subjects") return "subjects_directory";
  if (pathname.startsWith("/flashcards/")) return "flashcard_deck";
  if (pathname === "/flashcards") return "flashcards_directory";
  if (pathname === "/pyqs") return "pyqs_library";
  if (pathname === "/feedback") return "feedback";
  if (pathname === "/") return "home";
  return "page";
}

function getResourceId(pathname: string): string | null {
  if (isAdminRoute(pathname)) return null;
  if (pathname.startsWith("/subjects/")) return pathname.split("/")[2] || null;
  if (pathname.startsWith("/flashcards/")) return pathname.split("/")[2] || null;
  return null;
}

function getOrCreateSessionToken(): string {
  const now = Date.now();
  try {
    const rawSession = sessionStorage.getItem(SESSION_STORAGE_KEY);
    if (rawSession) {
      const parsed = JSON.parse(rawSession);
      if (parsed.token && now - Number(parsed.lastActiveAt || 0) < SESSION_TIMEOUT_MS) {
        parsed.lastActiveAt = now;
        sessionStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(parsed));
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(parsed));
        return parsed.token;
      }
    }

    const rawLocal = localStorage.getItem(LOCAL_STORAGE_KEY);
    if (rawLocal) {
      const parsed = JSON.parse(rawLocal);
      if (parsed.token && now - Number(parsed.lastActiveAt || 0) < SESSION_TIMEOUT_MS) {
        parsed.lastActiveAt = now;
        sessionStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(parsed));
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(parsed));
        return parsed.token;
      }
    }
  } catch {
    // Storage access error or private mode
  }

  const newToken = typeof crypto !== "undefined" && crypto.randomUUID ? crypto.randomUUID() : `cue_s_${now}_${Math.random().toString(36).slice(2, 9)}`;
  const record = { token: newToken, lastActiveAt: now };
  try {
    sessionStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(record));
    localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(record));
  } catch {
    // Ignore storage quota errors
  }
  return newToken;
}

export function ActivityTracker() {
  const { user } = useAuth();
  const pathname = usePathname();

  const sessionTokenRef = useRef<string>("");
  const previousPathnameRef = useRef<string>(pathname);
  const pathnameRef = useRef<string>(pathname);
  const accumulatedSecondsRef = useRef<number>(0);
  const lastInteractionRef = useRef<number>(Date.now());
  const lastThrottledRef = useRef<number>(0);
  const isFlushingRef = useRef<boolean>(false);

  const flushHeartbeat = (isClosing = false, overridePath?: string) => {
    if (!sessionTokenRef.current || isFlushingRef.current) return;
    const currentPath = overridePath || pathnameRef.current || (typeof window !== "undefined" ? window.location.pathname : "/");

    // Administrative activity inside the Admin Panel must NEVER contribute to Study Time
    if (isInAdminContext(currentPath)) {
      accumulatedSecondsRef.current = 0;
      return;
    }

    const delta = accumulatedSecondsRef.current;
    if (delta <= 0 && !isClosing) return;

    accumulatedSecondsRef.current = 0;
    const payload = {
      sessionToken: sessionTokenRef.current,
      deltaSeconds: delta,
      pagePath: currentPath,
      isClosing,
      resourceType: getResourceType(currentPath),
      resourceId: getResourceId(currentPath),
      metadata: {
        timestamp: new Date().toISOString(),
      },
    };

    const now = Date.now();
    try {
      const record = { token: sessionTokenRef.current, lastActiveAt: now };
      sessionStorage.setItem(SESSION_STORAGE_KEY, JSON.stringify(record));
      localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(record));
    } catch {
      // Ignore storage errors
    }

    if (isClosing && typeof navigator !== "undefined" && typeof navigator.sendBeacon === "function") {
      try {
        const blob = new Blob([JSON.stringify(payload)], { type: "application/json" });
        const sent = navigator.sendBeacon("/api/activity/heartbeat", blob);
        if (sent) return;
      } catch {
        // Fallback to fetch keepalive
      }
    }

    if (typeof fetch === "function") {
      isFlushingRef.current = true;
      fetch("/api/activity/heartbeat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
        keepalive: isClosing,
      })
        .catch(() => {})
        .finally(() => {
          isFlushingRef.current = false;
        });
    }
  };

  // Route change: flush any seconds accumulated on the previous student-facing page
  useEffect(() => {
    if (!user) return;
    const oldPath = previousPathnameRef.current;
    previousPathnameRef.current = pathname;
    pathnameRef.current = pathname;

    if (accumulatedSecondsRef.current > 0 && !isInAdminContext(oldPath)) {
      flushHeartbeat(false, oldPath);
    } else {
      accumulatedSecondsRef.current = 0;
    }
  }, [pathname, user]);

  // Main lifecycle & interval tracking
  useEffect(() => {
    if (!user) {
      if (sessionTokenRef.current && accumulatedSecondsRef.current > 0) {
        flushHeartbeat(true);
      }
      sessionTokenRef.current = "";
      return;
    }

    // Initialize or continue session
    sessionTokenRef.current = getOrCreateSessionToken();
    lastInteractionRef.current = Date.now();

    // Initial heartbeat to register session start if on a student-facing study page
    if (!isInAdminContext(pathnameRef.current)) {
      flushHeartbeat(false);
    }

    // Track user activity on window
    const onUserInteraction = () => {
      const now = Date.now();
      if (now - lastThrottledRef.current > 1500) {
        lastThrottledRef.current = now;
        lastInteractionRef.current = now;
      }
    };

    const interactionEvents: (keyof WindowEventMap)[] = ["mousedown", "keydown", "touchstart", "scroll", "mousemove"];
    interactionEvents.forEach((ev) => window.addEventListener(ev, onUserInteraction, { passive: true }));

    // Visibility change handler (tab switching / minimize)
    const onVisibilityChange = () => {
      if (document.visibilityState === "hidden") {
        flushHeartbeat(false);
      } else if (document.visibilityState === "visible") {
        lastInteractionRef.current = Date.now();
        // If away for longer than session timeout, roll a new session token
        try {
          const raw = sessionStorage.getItem(SESSION_STORAGE_KEY);
          if (raw) {
            const parsed = JSON.parse(raw);
            if (Date.now() - Number(parsed.lastActiveAt || 0) > SESSION_TIMEOUT_MS) {
              sessionTokenRef.current = getOrCreateSessionToken();
            }
          }
        } catch {
          // Ignore
        }
      }
    };
    document.addEventListener("visibilitychange", onVisibilityChange);

    // Page leave / unload handlers
    const onPageHide = () => {
      flushHeartbeat(true);
    };
    const onBeforeUnload = () => {
      flushHeartbeat(true);
    };

    window.addEventListener("pagehide", onPageHide);
    window.addEventListener("beforeunload", onBeforeUnload);

    // Active seconds ticker (runs every 1 second)
    const intervalTimer = window.setInterval(() => {
      const currentPath = pathnameRef.current || (typeof window !== "undefined" ? window.location.pathname : "/");

      // Admin Panel activity is administrative activity, NOT study activity.
      // Strictly never accumulate study time while inside the Admin Panel.
      if (isInAdminContext(currentPath)) {
        accumulatedSecondsRef.current = 0;
        return;
      }

      const now = Date.now();
      const isVisible = typeof document !== "undefined" && document.visibilityState === "visible";
      const isUserActive = now - lastInteractionRef.current <= INACTIVITY_THRESHOLD_MS;

      if (isVisible && isUserActive) {
        accumulatedSecondsRef.current += 1;
        if (accumulatedSecondsRef.current >= HEARTBEAT_INTERVAL_SECONDS) {
          flushHeartbeat(false);
        }
      }
    }, 1000);

    return () => {
      window.clearInterval(intervalTimer);
      interactionEvents.forEach((ev) => window.removeEventListener(ev, onUserInteraction));
      document.removeEventListener("visibilitychange", onVisibilityChange);
      window.removeEventListener("pagehide", onPageHide);
      window.removeEventListener("beforeunload", onBeforeUnload);
      flushHeartbeat(false);
    };
  }, [user]);

  return null;
}
