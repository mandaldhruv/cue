"use client";

import type { PDFDocumentProxy, RenderTask } from "pdfjs-dist";
import { useEffect, useRef, useState } from "react";

function PdfPage({ document, pageNumber, width, title }: { document: PDFDocumentProxy; pageNumber: number; width: number; title: string }) {
  const frameRef = useRef<HTMLDivElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const renderRef = useRef<RenderTask | null>(null);
  const [nearby, setNearby] = useState(false);
  const [ready, setReady] = useState(false);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    const frame = frameRef.current;
    if (!frame) return;
    const observer = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) { setNearby(true); observer.disconnect(); }
    }, { rootMargin: "700px 0px" });
    observer.observe(frame);
    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!nearby || !canvas || !width) return;
    let disposed = false;

    void (async () => {
      try {
        renderRef.current?.cancel();
        const page = await document.getPage(pageNumber);
        const baseViewport = page.getViewport({ scale: 1 });
        const cssScale = Math.min(width / baseViewport.width, 1.65);
        const pixelScale = Math.min(window.devicePixelRatio || 1, 2);
        const viewport = page.getViewport({ scale: cssScale * pixelScale });
        canvas.width = Math.floor(viewport.width);
        canvas.height = Math.floor(viewport.height);
        canvas.style.width = `${Math.floor(viewport.width / pixelScale)}px`;
        canvas.style.height = `${Math.floor(viewport.height / pixelScale)}px`;
        const task = page.render({ canvas, viewport });
        renderRef.current = task;
        await task.promise;
        if (!disposed) { setReady(true); setFailed(false); }
      } catch (caught) {
        if (!disposed && !(caught instanceof Error && caught.name === "RenderingCancelledException")) setFailed(true);
      }
    })();

    return () => { disposed = true; renderRef.current?.cancel(); };
  }, [document, nearby, pageNumber, width]);

  return <div ref={frameRef} className={`pdf-continuous-page ${ready ? "ready" : ""}`}>
    <span>Page {pageNumber}</span>
    {!ready && !failed && <div className="pdf-page-placeholder" aria-label={`Loading page ${pageNumber}`}><i/></div>}
    {failed && <div className="pdf-page-failed">Page {pageNumber} could not be rendered.</div>}
    <canvas ref={canvasRef} aria-label={`${title}, page ${pageNumber}`}/>
  </div>;
}

export default function PdfCanvasPreview({ blob, title }: { blob: Blob; title: string }) {
  const hostRef = useRef<HTMLDivElement>(null);
  const [pdfDocument, setPdfDocument] = useState<PDFDocumentProxy | null>(null);
  const [pageCount, setPageCount] = useState(0);
  const [hostWidth, setHostWidth] = useState(0);
  const [documentVersion, setDocumentVersion] = useState(0);
  const [error, setError] = useState("");

  useEffect(() => {
    const host = hostRef.current;
    if (!host) return;
    const observer = new ResizeObserver(([entry]) => setHostWidth(Math.max(260, entry.contentRect.width - 28)));
    observer.observe(host);
    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    let disposed = false;
    let loadingTask: ReturnType<(typeof import("pdfjs-dist/legacy/build/pdf.mjs"))["getDocument"]> | null = null;
    let loadedDocument: PDFDocumentProxy | null = null;

    void (async () => {
      try {
        // The legacy PDF.js build includes the browser polyfills required by
        // older iPadOS/Safari releases. The standard build relies on newer
        // APIs such as Promise.withResolvers and can fail before opening a
        // perfectly valid PDF on those devices.
        const pdfjs = await import("pdfjs-dist/legacy/build/pdf.mjs");
        if (!disposed) setError("");
        pdfjs.GlobalWorkerOptions.workerSrc = new URL("pdfjs-dist/legacy/build/pdf.worker.min.mjs", import.meta.url).toString();
        loadingTask = pdfjs.getDocument({ data: new Uint8Array(await blob.arrayBuffer()) });
        const document = await loadingTask.promise;
        if (disposed) { await document.cleanup(); return; }
        loadedDocument = document;
        setPdfDocument(document);
        setPageCount(document.numPages);
        setDocumentVersion((value) => value + 1);
      } catch {
        if (!disposed) setError("This PDF could not be rendered in the preview. Please use Download PDF instead.");
      }
    })();

    return () => {
      disposed = true;
      void loadingTask?.destroy();
      if (loadedDocument) void loadedDocument.cleanup();
    };
  }, [blob]);

  return <div className="pdf-canvas-viewer continuous">
    <div className="pdf-canvas-stage" ref={hostRef} aria-busy={!pageCount && !error}>
      {!pageCount && !error && <div className="pdf-canvas-loading" role="status"><i/><span>Preparing PDF…</span></div>}
      {error && <div className="pdf-canvas-error"><b>Preview unavailable</b><span>{error}</span></div>}
      {pdfDocument && pageCount > 0 && hostWidth > 0 && <div className="pdf-page-stack" aria-label={`${title}, ${pageCount} pages`}>
        {Array.from({ length: pageCount }, (_, index) => <PdfPage key={`${documentVersion}-${index + 1}`} document={pdfDocument} pageNumber={index + 1} width={hostWidth} title={title}/>)}
      </div>}
    </div>
  </div>;
}
