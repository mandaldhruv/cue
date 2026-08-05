import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({ variable: "--font-geist-sans", subsets: ["latin"] });
const geistMono = Geist_Mono({ variable: "--font-geist-mono", subsets: ["latin"] });

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:5173"),
  title: "Cue — Study smarter. Stress less.",
  description: "A calmer, smarter study platform for BMS students. Find notes, PYQs, flashcards and AI-powered exam insights in one beautiful space.",
  icons: { icon: "/favicon.svg", shortcut: "/favicon.svg" },
  openGraph: {
    title: "Cue — Study smarter. Stress less.",
    description: "Notes, PYQs, flashcards and exam insights in one calm space.",
    type: "website",
    images: [{ url: "/og.png", width: 1536, height: 1024, alt: "Cue — Study smarter. Stress less." }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Cue — Study smarter. Stress less.",
    description: "Notes, PYQs, flashcards and exam insights in one calm space.",
    images: ["/og.png"],
  },
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body className={`${geistSans.variable} ${geistMono.variable}`}>{children}</body></html>;
}
