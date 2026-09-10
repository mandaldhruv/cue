/* eslint-disable @next/next/no-img-element */
"use client";

import { createBrowserClient } from "@insforge/sdk/ssr";
import { useState } from "react";
import { emptyRichDocument, isRichDocument, legacyDocument, type RichDocument } from "../../flashcards/rich-content";

type Block = RichDocument["blocks"][number];

const uid = () => crypto.randomUUID();
const cleanName = (name: string) => name.toLowerCase().replace(/[^a-z0-9.-]+/g, "-").replace(/-+/g, "-");

export default function RichContentEditor({ name, label, initial, fallback, required = false }: { name: string; label: string; initial?: RichDocument | null; fallback?: string; required?: boolean }) {
  const [document, setDocument] = useState<RichDocument>(isRichDocument(initial) ? initial : fallback ? legacyDocument(fallback) : emptyRichDocument());
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState("");

  function change(id: string, next: Block) {
    setDocument((current) => ({ ...current, blocks: current.blocks.map((block) => block.id === id ? next : block) }));
  }

  function add(type: Block["type"]) {
    const block: Block = type === "text"
      ? { id: uid(), type, style: "paragraph", text: "" }
      : type === "bulletList" || type === "numberList"
        ? { id: uid(), type, items: [""] }
        : type === "table"
          ? { id: uid(), type, rows: [["", ""], ["", ""]] }
          : { id: uid(), type, url: "", key: "", alt: "" };
    setDocument((current) => ({ ...current, blocks: [...current.blocks, block] }));
  }

  function move(index: number, direction: -1 | 1) {
    setDocument((current) => {
      const blocks = [...current.blocks];
      const target = index + direction;
      if (target < 0 || target >= blocks.length) return current;
      [blocks[index], blocks[target]] = [blocks[target], blocks[index]];
      return { ...current, blocks };
    });
  }

  async function uploadImage(file: File, block: Extract<Block, { type: "image" }>) {
    setError("");
    if (!file.type.startsWith("image/")) return setError("Choose a JPG, PNG or WebP image.");
    if (file.size > 5 * 1024 * 1024) return setError("Keep each image under 5 MB.");
    setUploading(true);
    const key = `${crypto.randomUUID()}/${Date.now()}-${cleanName(file.name)}`;
    const { data, error: uploadError } = await createBrowserClient().storage.from("cue-flashcards").upload(key, file);
    setUploading(false);
    if (uploadError || !data) return setError(uploadError?.message ?? "Image upload failed.");
    change(block.id, { ...block, url: data.url, key: data.key, alt: block.alt || file.name.replace(/\.[^.]+$/, "") });
  }

  return <fieldset className="rich-editor">
    <legend>{label}{required ? " *" : ""}</legend>
    <input type="hidden" name={name} value={JSON.stringify(document)}/>
    <div className="rich-editor-toolbar" aria-label={`Add content to ${label}`}>
      <button type="button" onClick={() => add("text")}>+ Text</button>
      <button type="button" onClick={() => add("bulletList")}>+ List</button>
      <button type="button" onClick={() => add("table")}>+ Table</button>
      <button type="button" onClick={() => add("image")}>+ Image</button>
    </div>
    {!document.blocks.length && <button className="rich-editor-empty" type="button" onClick={() => add("text")}>Add the first content block</button>}
    <div className="rich-editor-blocks">{document.blocks.map((block, index) => <div className="rich-editor-block" key={block.id}>
      <div className="rich-block-controls"><span>{String(index + 1).padStart(2, "0")}</span><button type="button" disabled={index === 0} onClick={() => move(index, -1)}>↑</button><button type="button" disabled={index === document.blocks.length - 1} onClick={() => move(index, 1)}>↓</button><button type="button" className="danger" onClick={() => setDocument((current) => ({ ...current, blocks: current.blocks.filter((item) => item.id !== block.id) }))}>Remove</button></div>
      {block.type === "text" && <><div className="rich-text-options"><select value={block.style} onChange={(event) => change(block.id, { ...block, style: event.target.value as "paragraph" | "heading" })}><option value="paragraph">Paragraph</option><option value="heading">Heading</option></select><button type="button" className={block.bold ? "active" : ""} onClick={() => change(block.id, { ...block, bold: !block.bold })}><b>B</b></button><button type="button" className={block.italic ? "active" : ""} onClick={() => change(block.id, { ...block, italic: !block.italic })}><i>I</i></button></div><textarea rows={block.style === "heading" ? 2 : 4} value={block.text} onChange={(event) => change(block.id, { ...block, text: event.target.value })} placeholder={block.style === "heading" ? "Add a heading" : "Write formatted content"}/></>}
      {(block.type === "bulletList" || block.type === "numberList") && <div className="rich-list-editor">{block.items.map((item, itemIndex) => <div key={`${block.id}-${itemIndex}`}><span>{block.type === "numberList" ? `${itemIndex + 1}.` : "•"}</span><input value={item} onChange={(event) => change(block.id, { ...block, items: block.items.map((old, i) => i === itemIndex ? event.target.value : old) })}/><button type="button" onClick={() => change(block.id, { ...block, items: block.items.filter((_, i) => i !== itemIndex) })}>×</button></div>)}<button type="button" onClick={() => change(block.id, { ...block, items: [...block.items, ""] })}>+ List item</button><button type="button" onClick={() => change(block.id, { ...block, type: block.type === "bulletList" ? "numberList" : "bulletList" })}>Use {block.type === "bulletList" ? "numbered" : "bullet"} list</button></div>}
      {block.type === "table" && <div className="rich-table-editor"><div className="rich-table-scroll"><table><tbody>{block.rows.map((row, rowIndex) => <tr key={`${block.id}-${rowIndex}`}>{row.map((cell, cellIndex) => <td key={`${block.id}-${rowIndex}-${cellIndex}`}><input aria-label={`Row ${rowIndex + 1}, column ${cellIndex + 1}`} value={cell} onChange={(event) => change(block.id, { ...block, rows: block.rows.map((oldRow, r) => oldRow.map((oldCell, c) => r === rowIndex && c === cellIndex ? event.target.value : oldCell)) })}/></td>)}</tr>)}</tbody></table></div><div><button type="button" onClick={() => change(block.id, { ...block, rows: [...block.rows, Array(block.rows[0]?.length || 2).fill("")] })}>+ Row</button><button type="button" onClick={() => change(block.id, { ...block, rows: block.rows.map((row) => [...row, ""]) })}>+ Column</button></div></div>}
      {block.type === "image" && <div className="rich-image-editor">{block.url ? <img src={block.url} alt={block.alt}/> : <div>IMAGE</div>}<label><span>{uploading ? "Uploading…" : "Choose image"}</span><input type="file" accept="image/jpeg,image/png,image/webp" disabled={uploading} onChange={(event) => { const file = event.target.files?.[0]; if (file) void uploadImage(file, block); }}/></label><input value={block.alt} onChange={(event) => change(block.id, { ...block, alt: event.target.value })} placeholder="Image description for accessibility"/><input value={block.caption ?? ""} onChange={(event) => change(block.id, { ...block, caption: event.target.value })} placeholder="Optional caption"/></div>}
    </div>)}</div>
    {error && <small className="rich-editor-error">{error}</small>}
  </fieldset>;
}
