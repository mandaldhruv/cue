import type { Metadata } from "next";
import { notFound, redirect } from "next/navigation";
import { Footer, Navigation } from "../../components";
import { getPublishedContent, getPublishedSubject } from "../../lib/public-content";
import SubjectWorkspace from "./SubjectWorkspace";

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params;
  const { subject } = await getPublishedSubject(slug);
  if (!subject) return { title: "Subject not found · Cue" };
  return { title: `${subject.name} · Cue`, description: subject.description || `Study material for ${subject.name}, BMS Semester ${subject.semester_number}.` };
}

export default async function SubjectPage({
  params,
  searchParams,
}: {
  params: Promise<{ slug: string }>;
  searchParams?: Promise<{ tab?: string }>;
}) {
  const { slug } = await params;
  const search = await searchParams;
  if (search?.tab === "flashcard" || search?.tab === "flashcards") {
    redirect(`/flashcards/${slug}`);
  }
  const { subject } = await getPublishedSubject(slug);
  if (!subject) notFound();
  const { content, error } = await getPublishedContent(subject.id);
  return <><Navigation/><main><SubjectWorkspace subject={subject} content={content} loadError={Boolean(error)}/></main><Footer/></>;
}
