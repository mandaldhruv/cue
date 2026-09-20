"use client";

import { useRouter } from "next/navigation";
import { useEffect } from "react";

export default function AdminDashboardRefresh() {
  const router = useRouter();

  useEffect(() => {
    const refresh = () => router.refresh();
    const onVisibilityChange = () => {
      if (document.visibilityState === "visible") refresh();
    };
    const interval = window.setInterval(refresh, 30_000);
    window.addEventListener("focus", refresh);
    document.addEventListener("visibilitychange", onVisibilityChange);
    return () => {
      window.clearInterval(interval);
      window.removeEventListener("focus", refresh);
      document.removeEventListener("visibilitychange", onVisibilityChange);
    };
  }, [router]);

  return null;
}
