# Bookstoast Rebrand: Complete Session Context & Status Record

> **Status:** All 54 files rebranded, builds passing, test suites passing, changes staged in Git.  
> **Last Updated:** September 5, 2026

---

## 1. Safety Architecture: The 80/20 Rule

We strictly separate **Product Identity** from **Core Machinery**:
* **Untouched (Core Machinery):**
  * `@tryghost/*` internal npm package identifiers and dependency graphs.
  * Knex / MySQL database schema migration tables and column names.
  * Internal API routes (e.g. `/ghost/api/admin/`).
  * React component export APIs (e.g., Shade exports `<GhostLogo />` and `<GhostOrb />` remain unchanged, but their internal SVG vectors render Bookstoast artwork).
* **Rebranded (Product Identity):**
  * Visual assets (SVGs, PNGs, favicons, animated SVG loaders, apple-touch-icons).
  * Visitor and public surfaces ("Powered by Bookstoast", private blog gate, Portal links).
  * Document `<title>`, meta tags, and web app manifests.
  * Admin onboarding checklist, setup screens, Pro upgrade banner, and sidebar headers.
  * Transactional emails (invite user, welcome member, notification, sender title).
  * Default site settings (`default-settings.json`), seed fixtures, and canary integrity tests.

---

## 2. All Modified & Added Files (54 Files Total)

### A. Core Branding & Visual Assets
* `apps/shade/src/assets/images/ghost-logo.svg` (Bookstoast full wordmark)
* `apps/shade/src/assets/images/ghost-orb.svg` (Bookstoast toast icon mark)
* `apps/admin/src/assets/images/admin-loader.svg` (Animated steaming toast loader)
* `apps/ember-admin/public/assets/icons/admin-loader.svg` (Animated steaming toast loader)
* `apps/portal/src/images/ghost-logo-small.svg` (Bookstoast icon mark for Portal)
* `apps/admin/src/assets/images/ghost-pro-logo.png` & `ghost-pro-logo-dark.png`
* `apps/admin/src/assets/img/apple-touch-icon.png` & `apps/admin/src/assets/img/favicon.ico`
* `apps/admin/src/settings/assets/images/ghost-favicon.png`
* `apps/ember-admin/public/assets/icons/default-favicon.svg`
* `apps/ember-admin/public/assets/icons/ghost-orb.svg` & `ghost-orb-pink.svg`
* `apps/ember-admin/public/assets/img/logos/ghost-logo-black-1.png`
* `apps/ember-admin/public/assets/img/logos/orb-black-1.png` through `5.png` & `orb-pink-3.png`
* `apps/ember-admin/public/assets/img/touch-icon-ipad.png` & `touch-icon-iphone.png`
* `ghost/core/core/frontend/public/favicon.ico`

### B. Admin & Onboarding (React & Ember)
* `apps/admin/index.html` (Title: "Bookstoast", meta tags, SVG loader inlined)
* `apps/ember-admin/app/index.html` (Title: "Bookstoast", meta tags, loader)
* `apps/admin/src/layout/app-sidebar/app-sidebar-header.tsx` (Fallback site icon to Bookstoast orb)
* `apps/admin/src/layout/app-sidebar/upgrade-banner.tsx` ("Bookstoast Pro")
* `apps/admin/src/onboarding/components/onboarding-checklist.tsx` ("Start a new Bookstoast publication")
* `apps/ember-admin/app/templates/setup.hbs` (Welcome screen & copy)
* `apps/ember-admin/app/helpers/site-icon-style.js` (Fallback icon)
* `apps/admin/src/settings/layout/sidebar.tsx` ("About Bookstoast")
* `apps/admin/src/settings/general/about.tsx` ("Get help with Bookstoast")
* `apps/ember-admin/app/components/modals/settings/about.hbs` ("About Bookstoast")
* `apps/admin/src/settings/advanced/integrations.tsx` ("Make Bookstoast work with apps and tools")
* `apps/admin/src/settings/growth/recommendations/recommendation-icon.tsx` (Bookstoast hint)
* `apps/admin-toolbar/src/components.js` ("Bookstoast admin toolbar")

### C. "Powered by Ghost" Elimination & Visitor UI
* `apps/portal/src/components/common/powered-by.jsx` ("Powered by Bookstoast", link to `https://bookstoast.com`)
* `apps/admin/src/settings/email-design/email-preview.tsx` ("Powered by Bookstoast")
* `apps/admin/src/settings/email/newsletters/newsletter-preview-content.tsx` ("Powered by Bookstoast", link to `https://bookstoast.com`)
* `ghost/core/core/frontend/apps/private-blogging/lib/views/private.hbs` ("Powered by Bookstoast" + toast icon)

### D. Transactional Emails
* `ghost/core/core/server/services/mail/templates/welcome.html` & `raw/welcome.html`
* `ghost/core/core/server/services/mail/templates/invite-user.html` & `raw/invite-user.html`
* `ghost/core/core/server/services/mail/templates/invite-user-by-api-key.html`
* `ghost/core/core/server/services/mail/templates/notification.html`
* `ghost/core/core/server/services/mail/ghost-mailer.js` (Default sender: `'Bookstoast at {domain}'`)
* `ghost/core/core/server/services/email-service/email-templates/template.hbs`
* `ghost/core/core/server/services/member-welcome-emails/email-templates/wrapper.hbs`

### E. Seed Fixtures & Database Canary Tests
* `ghost/core/core/server/data/schema/default-settings/default-settings.json` (Site title: "Bookstoast")
* `ghost/core/test/utils/fixtures/default-settings.json`
* `ghost/core/core/server/data/schema/fixtures/fixtures.json` ("About this site" seed copy)
* `ghost/core/test/unit/server/data/schema/integrity.test.js` (Recomputed MD5 canary hashes)
* `apps/portal/test/portal-links.test.jsx` (Rebranded test assertions)

---

## 3. Test & Build Results

| Component / Test Suite | Command | Result |
| :--- | :--- | :--- |
| **Shade Library** | `pnpm --filter @tryghost/shade build` | **PASSED** (0 TypeScript errors) |
| **Admin Production Bundle** | `pnpm --filter @tryghost/admin build` | **PASSED** (28.74s Vite build) |
| **DB Canary Integrity** | `pnpm --filter ghost test:unit test/unit/server/data/schema/integrity.test.js` | **PASSED** (100% hash match) |
| **Portal Links & Branding** | `pnpm --filter @tryghost/portal test test/portal-links.test.jsx` | **PASSED** (37/37 passed) |

---

## 4. How to Access and Test Locally

1. **In GitHub Codespaces**, open the **Ports** tab in the bottom panel.
2. Verify / click:
   * **Port 2368 (Ghost Gateway):**
     * Visitor Homepage: `https://<codespace-id>-2368.app.github.dev/`
     * Admin Dashboard: `https://<codespace-id>-2368.app.github.dev/ghost/`
   * **Port 8025 (Mailpit Email Inbox):**
     * View captured transactional emails with Bookstoast branding.

---

## 5. Next Steps Upon Reopening

1. Inspect the browser preview on port `2368` and `/ghost/`.
2. (Optional) Run local Docker build check:
   ```bash
   docker build --target full -t bookstoast-platform:test -f Dockerfile.production .
   ```
3. Commit the staged changes:
   ```bash
   git commit -m "🎨 Changed default branding and visitor/admin UI assets to Bookstoast" -m "no ref" -m "Rebrand user-facing touchpoints from Ghost to Bookstoast using the canonical asset kit:
   - Replaced visual icons, logos, favicons, and animated loaders across Admin, Ember Admin, Shade, and Portal.
   - Rebranded visitor-facing surfaces (Powered by Bookstoast, private blog gate).
   - Updated transactional email templates and default mailer sender strings.
   - Updated default site settings and seed fixtures, re-verifying schema hashes.
   - Preserved internal machinery, API route handlers, and @tryghost/* packages."
   ```
