# testkozeppont.hu — Handoff Document for Levi

Everything you need to continue developing the landing page.

---

## Live Site

- **URL**: https://testkozeppont.hu
- **Also accessible at**: https://adorable-granita-64a399.netlify.app

---

## Project Files

The entire site lives in one folder. Copy this to your computer:

```
levi/
  index.html              ← the full landing page (single file, all CSS/JS inline)
  images/
    1-back-pain.jpg       ← AI-generated placeholder (replace with real photos)
    2-neck-shoulders.jpg
    3-exhausted.jpg
    4-brain-fog.jpg
    5-tried-everything.jpg
    6-getting-worse.jpg
```

No build step, no framework — just static HTML. Open `index.html` in a browser to preview locally.

---

## Hosting: Netlify (free tier)

| Field | Value |
|-------|-------|
| **Platform** | https://app.netlify.com |
| **Account** | Logged in as "Testkozeppont" team |
| **Project name** | `adorable-granita-64a399` |
| **Site ID** | `a0477132-2c40-498e-8c71-59724cb7e176` |
| **Dashboard** | https://app.netlify.com/projects/adorable-granita-64a399 |
| **Domain settings** | https://app.netlify.com/projects/adorable-granita-64a399/domain-management |

### How to deploy changes

1. Install Node.js (18+): https://nodejs.org
2. Install Netlify CLI: `npm install -g netlify-cli`
3. Log in: `netlify login` (opens browser)
4. From the project folder, run:

```bash
cd levi/
netlify link --id a0477132-2c40-498e-8c71-59724cb7e176
netlify deploy --prod --dir=.
```

That's it — site updates in seconds.

---

## Domain: testkozeppont.hu (domdom.hu)

| Field | Value |
|-------|-------|
| **Registrar** | https://domdom.hu |
| **Account holder** | Farkas Levente |
| **Domain** | testkozeppont.hu |

### DNS Records (set in domdom.hu)

| Name | Type | Value |
|------|------|-------|
| `testkozeppont.hu` | A | `75.2.60.5` (Netlify load balancer) |
| `www.testkozeppont.hu` | A | `75.2.60.5` (Netlify load balancer) |

The nameservers remain domdom's defaults:
- `ns1.domdom.net`
- `ns2.domdom.net`
- `ns3.domdom.net`

HTTPS/SSL is auto-provisioned by Netlify (Let's Encrypt) — no action needed.

---

## External Services Used

| Service | What for | Cost |
|---------|----------|------|
| **Google Fonts** | Inter font family | Free (loaded via CSS @import) |
| **Font Awesome 6.5.1** | Icons (stars, check, arrows, user) | Free (loaded via CSS @import from cdnjs) |
| **Netlify** | Hosting | Free tier |
| **domdom.hu** | Domain registration | Paid (Levi's account) |

No API keys, no backend, no database. Everything is client-side.

---

## Form Submissions

**The form currently does NOT actually send data anywhere.** It just shows a success message client-side (JavaScript at the bottom of `index.html`). 

To make it work, options:
1. **Netlify Forms** (easiest) — add `netlify` attribute to the `<form>` tag: `<form id="signup-form" netlify>`. Submissions appear in the Netlify dashboard under Forms.
2. **Formspree / Formsubmit** — third-party form services, also free tier available.
3. **Custom backend** — only if you need more control.

---

## What to Replace / TODO

- [ ] **Pain point images** — the 6 images in `images/` are AI-generated placeholders. Replace with real photos of actual people.
- [ ] **Levi's photo** — footer has a placeholder icon where Levi's portrait should go. Add an image to `images/` and update the `<div class="footer-avatar">` section in `index.html`.
- [ ] **Footer "Ismerd meg Levit" link** — currently points to `#about-levi` which doesn't exist. Create an about page or section, or link to social media.
- [ ] **Form backend** — wire up the signup form to actually collect submissions (see above).
- [ ] **Testimonials** — the 3 testimonials (Balazs M., Kata R., Tamas P.) are placeholder copy. Replace with real client testimonials when available.

---

## Page Structure (sections in order)

1. **Nav** — logo "levi.fit", links to sections, CTA button
2. **Hero** — "Rendszeresen faj a hatad?" headline, subtitle, CTA, stats
3. **Pain Points** — 6 cards with images showing common problems
4. **How It Works** — 4 steps (assessment → plan → 1-on-1 → results)
5. **Testimonials** — 3 client reviews (placeholder)
6. **Sign Up Form** — name, email, phone, problem dropdown, notes
7. **Footer** — Levi bio/link + copyright

---

## Quick Reference: Edit Common Things

**Change the headline:**
```html
<h1>Rendszeresen <span class="highlight">faj a hatad?</span></h1>
```

**Change accent color (orange):**
```css
--accent: #e85d3a;
```

**Change Levi's bio text:**
Look for `<div class="footer-bio">` near the bottom of `index.html`.

**Add Levi's photo:**
Replace the `<i class="fa-solid fa-user footer-avatar-placeholder"></i>` inside `<div class="footer-avatar">` with `<img src="images/levi.jpg" alt="Levi">`.
