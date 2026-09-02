const features = [
  {
    title: 'Launch your journal',
    text: 'Create a publication with a dedicated publishing environment managed by Bookstoast.',
  },
  {
    title: 'Use your own domain',
    text: 'Connect a domain you already own or start with a Bookstoast journal address.',
  },
  {
    title: 'Publish professionally',
    text: 'Get the publishing tools you need without running the infrastructure yourself.',
  },
];

export default function HomePage() {
  return (
    <main>
      <nav className="nav shell" aria-label="Main navigation">
        <a className="brand" href="/" aria-label="Bookstoast home">
          <span className="brand-mark">B</span>
          <span>bookstoast</span>
        </a>
        <div className="nav-links">
          <a href="#how-it-works">How it works</a>
          <a href="#features">Features</a>
          <a className="nav-login" href="/signin">Sign in</a>
        </div>
      </nav>

      <section className="hero shell">
        <div className="hero-copy">
          <p className="eyebrow">SCHOLARLY PUBLISHING, REIMAGINED</p>
          <h1>Launch your journal.<br />Build your publication.</h1>
          <p className="hero-text">
            Bookstoast gives researchers and scholarly teams the infrastructure to launch a journal,
            publish openly, and run the publication without becoming a server administrator.
          </p>
          <div className="hero-actions">
            <a className="button button-primary" href="/start">Start your journal</a>
            <a className="button button-secondary" href="#how-it-works">See how it works</a>
          </div>
          <p className="hero-note">Your journal. Your domain. Your publication.</p>
        </div>

        <div className="hero-card" aria-label="Journal preview">
          <div className="window-top">
            <span></span><span></span><span></span>
          </div>
          <div className="journal-preview">
            <p className="preview-kicker">BOOKSTOAST JOURNAL</p>
            <h2>Journal of Open Research</h2>
            <p className="preview-meta">Independent scholarly publishing</p>
            <div className="preview-line"></div>
            <div className="preview-block"></div>
            <div className="preview-block short"></div>
            <div className="preview-footer">
              <span>ISSN 0000-0000</span>
              <span>Latest issue →</span>
            </div>
          </div>
        </div>
      </section>

      <section className="how shell" id="how-it-works">
        <div>
          <p className="eyebrow">HOW IT WORKS</p>
          <h2>One platform. Many journals.</h2>
        </div>
        <p className="section-intro">
          Bookstoast is the control layer. Each journal gets its own publishing environment,
          while domains, accounts, configuration, and infrastructure are managed from one place.
        </p>
      </section>

      <section className="features shell" id="features">
        {features.map((feature, index) => (
          <article className="feature" key={feature.title}>
            <span className="feature-number">0{index + 1}</span>
            <h3>{feature.title}</h3>
            <p>{feature.text}</p>
          </article>
        ))}
      </section>

      <section className="cta shell">
        <div>
          <p className="eyebrow">READY WHEN YOU ARE</p>
          <h2>Start with one journal.<br />Grow from there.</h2>
        </div>
        <a className="button button-primary" href="/start">Create a journal</a>
      </section>

      <footer className="footer shell">
        <span>© {new Date().getFullYear()} Bookstoast</span>
        <span>Scholarly publishing infrastructure</span>
      </footer>
    </main>
  );
}
