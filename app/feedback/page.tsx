import { Footer, Navigation } from "../components";
import FeedbackForm from "./FeedbackForm";
import TestimonialsSection from "./TestimonialsSection";

export const dynamic = "force-dynamic";

export default function FeedbackPage() {
  return <><Navigation/><main className="feedback-page-clean">
    <TestimonialsSection />
    <section className="feedback-clean-workspace"><div className="container"><FeedbackForm /></div></section>
  </main><Footer/></>;
}
