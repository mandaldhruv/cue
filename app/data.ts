export type Subject = {
  slug: string;
  code: string;
  name: string;
  shortName: string;
  description: string;
  units: string[];
  accent: string;
  papers: number;
  notes: number;
};

export const subjects: Subject[] = [
  { slug: "advertising", code: "ADV", name: "Advertising", shortName: "Advertising", description: "Strategy, media planning, creative execution and advertising regulation.", accent: "coral", papers: 6, notes: 12, units: ["Introduction to advertising", "Advertising agencies", "Media planning", "Creative strategy", "Ethics and regulation"] },
  { slug: "equity-and-debt-markets", code: "EDM", name: "Equity and Debt Markets", shortName: "Equity & Debt Markets", description: "Financial instruments, market structure, valuation and trading fundamentals.", accent: "blue", papers: 5, notes: 10, units: ["Financial markets", "Equity instruments", "Debt instruments", "Trading and settlement", "Market regulation"] },
  { slug: "business-planning-and-entrepreneurial-management", code: "BPEM", name: "Business Planning and Entrepreneurial Management", shortName: "Business Planning", description: "Opportunity evaluation, business planning and entrepreneurial management.", accent: "violet", papers: 5, notes: 11, units: ["Entrepreneurship foundations", "Idea and opportunity", "Business model", "Business plan", "Growth and funding"] },
  { slug: "accounting-for-managerial-decisions", code: "AMD", name: "Accounting for Managerial Decisions", shortName: "Managerial Accounting", description: "Accounting tools and analysis for confident managerial decision-making.", accent: "mint", papers: 6, notes: 14, units: ["Cost concepts", "Marginal costing", "Budgetary control", "Standard costing", "Decision analysis"] },
  { slug: "principles-of-economics-ii", code: "ECO II", name: "Principles of Economics II", shortName: "Economics II", description: "Macroeconomic principles, national income, policy and global trade.", accent: "amber", papers: 5, notes: 9, units: ["National income", "Money and inflation", "Business cycles", "Public finance", "International trade"] },
  { slug: "hindi-i", code: "HIN I", name: "Hindi I", shortName: "Hindi I", description: "Hindi language, communication and selected literature for Semester 3.", accent: "rose", papers: 4, notes: 8, units: ["गद्य", "पद्य", "व्यावहारिक हिंदी", "लेखन कौशल"] },
];

export const navItems = [
  { href: "/", label: "Home" },
  { href: "/subjects", label: "Subjects" },
  { href: "/flashcards", label: "Flashcards" },
  { href: "/pyqs", label: "PYQs" },
  { href: "/feedback", label: "Feedback" },
  { href: "/about", label: "About" },
];
