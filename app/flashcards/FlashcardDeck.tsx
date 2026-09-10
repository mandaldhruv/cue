"use client";

import { useState } from "react";
import type { PublicContentRecord, PublicFlashcardTopic, PublicFlashcardUnit } from "../lib/public-content";
import { RichContent } from "./rich-content";

export default function FlashcardDeck({ units, topics, cards, subjectName }: { units: PublicFlashcardUnit[]; topics: PublicFlashcardTopic[]; cards: PublicContentRecord[]; subjectName: string }) {
  const organisedCards = cards.filter((card) => card.flashcard_unit_id && card.flashcard_topic_id);
  const unassignedCards = cards.filter((card) => !card.flashcard_unit_id || !card.flashcard_topic_id);
  const availableUnits = units.filter((unit) => organisedCards.some((card) => card.flashcard_unit_id === unit.id));
  const [unitId, setUnitId] = useState(availableUnits[0]?.id ?? (unassignedCards.length ? "__unassigned__" : ""));
  const availableTopics = topics.filter((topic) => topic.unit_id === unitId && organisedCards.some((card) => card.flashcard_topic_id === topic.id));
  const [topicId, setTopicId] = useState("");
  const [viewerIndex, setViewerIndex] = useState<number | null>(null);
  const [revealed, setRevealed] = useState(false);

  const selectedTopicId = availableTopics.some((topic) => topic.id === topicId) ? topicId : availableTopics[0]?.id ?? "";
  const visibleCards = unitId === "__unassigned__" ? unassignedCards : cards.filter((card) => card.flashcard_topic_id === selectedTopicId);
  const selectedUnit = units.find((unit) => unit.id === unitId);
  const selectedTopic = topics.find((topic) => topic.id === selectedTopicId);
  const viewerCard = viewerIndex === null ? null : visibleCards[viewerIndex];
  const selectedTopicIndex = availableTopics.findIndex((topic) => topic.id === selectedTopicId);
  const canMovePrevious = viewerIndex !== null && (
    viewerIndex > 0 || (unitId !== "__unassigned__" && selectedTopicIndex > 0)
  );
  const canMoveNext = viewerIndex !== null && (
    viewerIndex < visibleCards.length - 1 ||
    (unitId !== "__unassigned__" && selectedTopicIndex >= 0 && selectedTopicIndex < availableTopics.length - 1)
  );

  function open(index: number) { setViewerIndex(index); setRevealed(false); }
  function move(direction: -1 | 1) {
    if (!visibleCards.length || viewerIndex === null) return;
    const nextIndex = viewerIndex + direction;
    if (nextIndex >= 0 && nextIndex < visibleCards.length) {
      setViewerIndex(nextIndex);
      setRevealed(false);
      return;
    }

    if (unitId === "__unassigned__") return;
    const adjacentTopic = availableTopics[selectedTopicIndex + direction];
    if (!adjacentTopic) return;
    const adjacentCards = cards.filter((card) => card.flashcard_topic_id === adjacentTopic.id);
    if (!adjacentCards.length) return;
    setTopicId(adjacentTopic.id);
    setViewerIndex(direction === 1 ? 0 : adjacentCards.length - 1);
    setRevealed(false);
  }

  if (!cards.length) return <div className="study-empty"><span>FLASHCARDS</span><h3>No cards published yet.</h3><p>The {subjectName} deck will appear here as soon as the admin publishes its first card.</p></div>;

  return <div className="flashcard-deck-browser">
    <aside className="flashcard-unit-nav"><header><span>DECK MAP</span><b>Choose a unit</b></header><nav>{availableUnits.map((unit, index) => {
      const unitCards = organisedCards.filter((card) => card.flashcard_unit_id === unit.id);
      return <button key={unit.id} className={unitId === unit.id ? "active" : ""} onClick={() => { setUnitId(unit.id); setTopicId(""); setViewerIndex(null); }}><i>{String(index + 1).padStart(2, "0")}</i><span><b>{unit.title}</b><small>{unitCards.length} {unitCards.length === 1 ? "card" : "cards"}</small></span><strong>→</strong></button>;
    })}{unassignedCards.length > 0 && <button className={unitId === "__unassigned__" ? "active" : ""} onClick={() => { setUnitId("__unassigned__"); setTopicId("__unassigned__"); setViewerIndex(null); }}><i>—</i><span><b>General cards</b><small>{unassignedCards.length} older {unassignedCards.length === 1 ? "card" : "cards"}</small></span><strong>→</strong></button>}</nav></aside>
    <section className="flashcard-topic-workspace"><header><div><span>{selectedUnit ? "UNIT" : "DECK"}</span><h2>{selectedUnit?.title ?? "General cards"}</h2></div><small>{availableTopics.length} {availableTopics.length === 1 ? "topic" : "topics"}</small></header>
      {unitId !== "__unassigned__" && <div className="flashcard-topic-tabs" role="tablist">{availableTopics.map((topic) => <button key={topic.id} role="tab" aria-selected={selectedTopicId === topic.id} className={selectedTopicId === topic.id ? "active" : ""} onClick={() => { setTopicId(topic.id); setViewerIndex(null); }}>{topic.title}<small>{organisedCards.filter((card) => card.flashcard_topic_id === topic.id).length}</small></button>)}</div>}
      <div className="flashcard-question-list"><div className="flashcard-question-heading"><span>{selectedTopic?.title ?? "Questions"}</span><small>{visibleCards.length} {visibleCards.length === 1 ? "question" : "questions"}</small></div>{visibleCards.length ? visibleCards.map((card, index) => <button key={card.id} onClick={() => open(index)}><i>{String(index + 1).padStart(2, "0")}</i><span><b>{card.title}</b>{card.description && <small>{card.description}</small>}</span><strong>View solution <em>→</em></strong></button>) : <div className="study-empty"><h3>No cards in this topic yet.</h3><p>Only content published by the admin appears here.</p></div>}</div>
    </section>

    {viewerCard && <div className="flashcard-viewer-backdrop" role="dialog" aria-modal="true" aria-label="Flashcard viewer" onMouseDown={() => setViewerIndex(null)}><article className="flashcard-viewer" onMouseDown={(event) => event.stopPropagation()}><header><div><span>{selectedTopic?.title ?? "FLASHCARD"}</span><small>{(viewerIndex ?? 0) + 1} / {visibleCards.length}</small></div><button onClick={() => setViewerIndex(null)} aria-label="Close flashcard">×</button></header><div className="flashcard-viewer-scroll"><section><span>QUESTION</span><RichContent document={viewerCard.question_document} fallback={viewerCard.title}/>{viewerCard.description && <aside><b>Hint</b><p>{viewerCard.description}</p></aside>}</section><button className="view-solution" onClick={() => setRevealed((value) => !value)} aria-expanded={revealed}>{revealed ? "Hide solution" : "View solution"}<span>{revealed ? "↑" : "↓"}</span></button><section className={`flashcard-solution ${revealed ? "revealed" : ""}`} aria-hidden={!revealed}><div><span>ANSWER</span><RichContent document={viewerCard.answer_document} fallback={viewerCard.body}/></div></section></div><footer><button onClick={() => move(-1)} disabled={!canMovePrevious}>← Previous</button><span>{(viewerIndex ?? 0) + 1} of {visibleCards.length}</span><button onClick={() => move(1)} disabled={!canMoveNext}>Next →</button></footer></article></div>}
  </div>;
}
