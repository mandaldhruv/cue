import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Footer, Navigation } from "../../components";
import { getPublishedFlashcardDeck, getPublishedSubject } from "../../lib/public-content";
import FlashcardDeck from "../FlashcardDeck";

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params;
  const { subject } = await getPublishedSubject(slug);
  return { title: subject ? `${subject.name} Flashcards · Cue` : "Flashcards · Cue" };
}

export default async function SubjectFlashcardsPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const { subject } = await getPublishedSubject(slug);
  if (!subject) notFound();
  const { units, topics, cards, error } = await getPublishedFlashcardDeck(subject.id);
  return <><Navigation/><main>
    <section className="deck-page-head" style={{ "--deck-accent": subject.accent_color } as React.CSSProperties}><div className="container"><Link href="/flashcards">← All decks</Link><span>{subject.short_code} · SEMESTER {subject.semester_number}</span><h1>{subject.name}</h1><p>{cards.length} published {cards.length === 1 ? "flashcard" : "flashcards"}</p></div></section>
    <section className="deck-player-section"><div className="container">{error ? <div className="study-empty error"><h3>This deck could not be loaded.</h3><p>Please try again in a moment.</p></div> : <FlashcardDeck units={units} topics={topics} cards={cards} subjectName={subject.name}/>}</div></section>
  </main><Footer/></>;
}
