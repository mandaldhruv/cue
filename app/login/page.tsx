import type { Metadata } from "next";
import { Logo } from "../components";
import LoginPanel from "./LoginPanel";

export const metadata: Metadata = { title: "Cue Login" };

function safeNext(value?: string) { return value?.startsWith("/") && !value.startsWith("//") ? value : "/"; }

export default async function LoginPage({ searchParams }: { searchParams: Promise<{ next?: string; error?: string }> }) {
  const query = await searchParams;
  return <main className="cue-login-page"><div className="cue-login-shell"><header><Logo/><a href={safeNext(query.next)}>Continue browsing <span>→</span></a></header><div className="cue-login-layout"><aside><span>STUDY WITHOUT THE CLUTTER</span><h2>One login.<br/><em>Everything in Cue.</em></h2><ul><li><i>01</i><div><b>Browse freely</b><small>Explore subjects, papers and flashcard questions before signing in.</small></div></li><li><i>02</i><div><b>Keep resources protected</b><small>Sign in only when you download a paper or reveal a solution.</small></div></li><li><i>03</i><div><b>Pick up where you left off</b><small>Your Cue account is ready for progress tracking as the platform grows.</small></div></li></ul></aside><LoginPanel next={safeNext(query.next)} googleError={query.error === "google"}/></div></div></main>;
}
