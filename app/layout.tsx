import type { Metadata } from "next";
import "./globals.css";
import "./enhancements.css";
import { AuthProvider } from "./auth/AuthProvider";

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:5173"),
  title: "Cue | Study smarter. Stress less.",
  description: "A calmer, smarter study platform for BMS students. Find syllabus, PYQs and flashcards in one beautiful space.",
  icons: {
    icon: [{ url: "/Favicon.png?v=20260918-2", type: "image/png", sizes: "1254x1254" }],
    shortcut: "/Favicon.png?v=20260918-2",
    apple: "/Favicon.png?v=20260918-2",
  },
  openGraph: {
    title: "Cue | Study smarter. Stress less.",
    description: "Syllabus, PYQs and flashcards in one calm space.",
    type: "website",
    images: [{ url: "/og.png", width: 1536, height: 1024, alt: "Cue | Study smarter. Stress less." }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Cue | Study smarter. Stress less.",
    description: "Syllabus, PYQs and flashcards in one calm space.",
    images: ["/og.png"],
  },
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en" data-scroll-behavior="smooth"><body><AuthProvider><div className="app-shell">{children}</div></AuthProvider></body></html>;
}
