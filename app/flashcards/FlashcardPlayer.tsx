"use client";

import { useState } from "react";
import { useAuth } from "../auth/AuthProvider";
import { RichContent, type RichDocument } from "./rich-content";

export type PublicFlashcard = { id: string; title: string; description: string; body: string; question_document?: RichDocument | null; answer_document?: RichDocument | null };

export default function FlashcardPlayer({ cards, subjectName }: { cards: PublicFlashcard[]; subjectName: string }) {
  const { requireLogin } = useAuth();
  const [index, setIndex] = useState(0);
  const [revealed, setRevealed] = useState(false);
  if (!cards.length) return <div className="study-empty"><span>FLASHCARDS</span><h3>No cards published yet.</h3><p>The {subjectName} deck will appear here as soon as cards are published from the admin workspace.</p></div>;

  const safeIndex = index % cards.length;
  const card = cards[safeIndex];

  function move(direction: number) {
    setIndex((current) => (current + direction + cards.length) % cards.length);
    setRevealed(false);
  }

  async function toggleSolution() {
    if (!revealed && !(await requireLogin())) return;
    setRevealed((value) => !value);
  }

  return <div className="flashcard-player">
    <div className="flashcard-player-head"><div><span>{subjectName.toUpperCase()} DECK</span><b>{cards.length} {cards.length === 1 ? "card" : "cards"}</b></div><small>{safeIndex + 1} / {cards.length}</small></div>
    <div className="study-flashcard-stage">
      <div className={`study-flashcard ${revealed ? "is-flipped" : ""}`}>
        <section className="study-flashcard-face study-flashcard-question" aria-hidden={revealed}>
          <div className="study-flashcard-label"><span>QUESTION</span><small>Think before you reveal</small></div>
          <div className="study-flashcard-content"><RichContent document={card.question_document} fallback={card.title}/>{card.description && <aside><b>Hint</b><p>{card.description}</p></aside>}</div>
          <button type="button" className="study-card-action" onClick={toggleSolution} tabIndex={revealed ? -1 : 0}>View solution <span>↻</span></button>
        </section>
        <section className="study-flashcard-face study-flashcard-answer" aria-hidden={!revealed}>
          <div className="study-flashcard-label"><span>ANSWER</span><small>Active recall</small></div>
          <div className="study-flashcard-content"><RichContent document={card.answer_document} fallback={card.body}/></div>
          <button type="button" className="study-card-action secondary" onClick={toggleSolution} tabIndex={revealed ? 0 : -1}>Show question <span>↻</span></button>
        </section>
      </div>
    </div>
    <div className="flashcard-controls"><button onClick={() => move(-1)} aria-label="Previous flashcard">← Previous</button><span>{safeIndex + 1} of {cards.length}</span><button onClick={() => move(1)} aria-label="Next flashcard">Next →</button></div>
  </div>;
}
