"use client";
import { useEffect, useRef, useState } from "react";

function CountValue({ value, pad, active }: { value: number; pad: number; active: boolean }) {
  const [display, setDisplay] = useState(0);
  useEffect(() => {
    if (!active) return;
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      const frame = requestAnimationFrame(() => setDisplay(value));
      return () => cancelAnimationFrame(frame);
    }
    const startedAt = performance.now();
    let frame = 0;
    const tick = (now: number) => {
      const progress = Math.min((now - startedAt) / 1250, 1);
      setDisplay(Math.round(value * (1 - Math.pow(1 - progress, 3))));
      if (progress < 1) frame = requestAnimationFrame(tick);
    };
    frame = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frame);
  }, [active, value]);
  return <b>{String(display).padStart(pad, "0")}</b>;
}

export default function CountUpStats({ subjects, resources, semesters }: { subjects: number; resources: number; semesters: number }) {
  const stats = [
    { value: subjects, label: "BMS subjects", pad: 2 },
    { value: resources, label: "Published resources", pad: 0 },
    { value: semesters, label: semesters === 1 ? "Available semester" : "Available semesters", pad: 0 },
  ];
  const sectionRef = useRef<HTMLDivElement>(null);
  const [active, setActive] = useState(false);
  useEffect(() => {
    const section = sectionRef.current;
    if (!section) return;
    const observer = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) { setActive(true); observer.disconnect(); }
    }, { threshold: 0.45 });
    observer.observe(section);
    return () => observer.disconnect();
  }, []);
  return <div className={`hero-trust count-up-stats ${active ? "counted" : ""}`} ref={sectionRef}>
    {stats.map((stat) => <div key={stat.label}><CountValue {...stat} active={active}/><span>{stat.label}</span></div>)}
  </div>;
}
