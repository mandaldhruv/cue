import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Cue Admin",
  robots: { index: false, follow: false },
};

export default function AdminLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return children;
}
