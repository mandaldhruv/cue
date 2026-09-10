/* eslint-disable @next/next/no-img-element */
import type { ReactNode } from "react";

export type RichTextBlock = {
  id: string;
  type: "text";
  style: "paragraph" | "heading";
  text: string;
  bold?: boolean;
  italic?: boolean;
};

export type RichListBlock = {
  id: string;
  type: "bulletList" | "numberList";
  items: string[];
};

export type RichTableBlock = {
  id: string;
  type: "table";
  rows: string[][];
};

export type RichImageBlock = {
  id: string;
  type: "image";
  url: string;
  key: string;
  alt: string;
  caption?: string;
};

export type RichDocument = {
  version: 1;
  blocks: Array<RichTextBlock | RichListBlock | RichTableBlock | RichImageBlock>;
};

export const emptyRichDocument = (): RichDocument => ({ version: 1, blocks: [] });

export function isRichDocument(value: unknown): value is RichDocument {
  if (!value || typeof value !== "object") return false;
  const candidate = value as { version?: unknown; blocks?: unknown };
  if (candidate.version !== 1 || !Array.isArray(candidate.blocks) || candidate.blocks.length > 100) return false;
  return candidate.blocks.every((unknownBlock) => {
    if (!unknownBlock || typeof unknownBlock !== "object") return false;
    const block = unknownBlock as Record<string, unknown>;
    if (typeof block.id !== "string" || typeof block.type !== "string") return false;
    if (block.type === "text") return (block.style === "paragraph" || block.style === "heading") && typeof block.text === "string";
    if (block.type === "bulletList" || block.type === "numberList") return Array.isArray(block.items) && block.items.length <= 100 && block.items.every((item) => typeof item === "string");
    if (block.type === "table") return Array.isArray(block.rows) && block.rows.length <= 50 && block.rows.every((row) => Array.isArray(row) && row.length <= 20 && row.every((cell) => typeof cell === "string"));
    if (block.type === "image") return typeof block.url === "string" && typeof block.key === "string" && typeof block.alt === "string" && (block.caption === undefined || typeof block.caption === "string");
    return false;
  });
}

export function legacyDocument(value: string): RichDocument {
  const text = value.trim();
  return text ? { version: 1, blocks: [{ id: "legacy", type: "text", style: "paragraph", text }] } : emptyRichDocument();
}

export function richDocumentText(document: RichDocument): string {
  return document.blocks.map((block) => {
    if (block.type === "text") return block.text;
    if (block.type === "bulletList" || block.type === "numberList") return block.items.join(" ");
    if (block.type === "table") return block.rows.flat().join(" ");
    if (block.type === "image") return block.alt || block.caption || "Image";
    return "";
  }).join(" ").replace(/\s+/g, " ").trim();
}

function StyledText({ block }: { block: RichTextBlock }) {
  const content: ReactNode = block.italic ? <em>{block.text}</em> : block.text;
  const styled = block.bold ? <strong>{content}</strong> : content;
  return block.style === "heading" ? <h3>{styled}</h3> : <p>{styled}</p>;
}

export function RichContent({ document, fallback = "" }: { document?: RichDocument | null; fallback?: string }) {
  const source = isRichDocument(document) && document.blocks.length ? document : legacyDocument(fallback);
  return <div className="rich-content">{source.blocks.map((block) => {
    if (block.type === "text") return <StyledText key={block.id} block={block}/>;
    if (block.type === "bulletList") return <ul key={block.id}>{block.items.filter(Boolean).map((item, index) => <li key={`${block.id}-${index}`}>{item}</li>)}</ul>;
    if (block.type === "numberList") return <ol key={block.id}>{block.items.filter(Boolean).map((item, index) => <li key={`${block.id}-${index}`}>{item}</li>)}</ol>;
    if (block.type === "table") return <div className="rich-table-wrap" key={block.id}><table><tbody>{block.rows.map((row, rowIndex) => <tr key={`${block.id}-${rowIndex}`}>{row.map((cell, cellIndex) => rowIndex === 0 ? <th key={`${block.id}-${rowIndex}-${cellIndex}`}>{cell}</th> : <td key={`${block.id}-${rowIndex}-${cellIndex}`}>{cell}</td>)}</tr>)}</tbody></table></div>;
    if (block.type === "image") return <figure key={block.id}><img src={block.url} alt={block.alt}/>{block.caption && <figcaption>{block.caption}</figcaption>}</figure>;
    return null;
  })}</div>;
}
