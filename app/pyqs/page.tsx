import { Footer, Navigation } from "../components";
import PyqLibrary from "./PyqLibrary";

export default function PyqsPage(){return <><Navigation/><main><section className="pyq-page-head"><div className="container"><span>PREVIOUS YEAR QUESTIONS · BMS</span><h1>Practice from the <em>real papers.</em></h1><p>Filter by subject or year, preview instantly and download only what you need.</p></div></section><section className="pyq-library-section"><div className="container"><PyqLibrary/></div></section></main><Footer/></>}
