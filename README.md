# Horizon of Avarice — Starter Website

This is a small static website scaffold created as a starting point.

Files:
- `index.html` — main page
- `styles.css` — styles
- `script.js` — small interactions (menu, theme toggle, contact demo)

How to open:
- Double-click `index.html` to open in your browser.
- Or, from VS Code, install the Live Server extension and click "Go Live" to serve it on localhost.

Next steps:
- Replace copy, images, and branding.
- Add real form handling or a backend.
- Add accessibility improvements and SEO meta.

Deploying this site (public URL)

1) GitHub Pages (recommended, free)

- Create a GitHub repository and push this folder as the repository root.
- In your repo add the workflow file in `.github/workflows/deploy.yml` (already included here). On push to `main`/`master` the action will publish the repo root to the `gh-pages` branch.
- In the repository Settings → Pages, set Source to the `gh-pages` branch (root). GitHub will provide a URL like `https://<your-username>.github.io/<repo-name>/`.

Default Pages URL for this project

- Once this repository is pushed and the deploy workflow completes, the default GitHub Pages URL will be:

	https://hnrksns-rgb.github.io/HorizonsofAvariceWeb-main/

- Note: If a `CNAME` file exists in the repository root, GitHub Pages will attempt to use that custom domain instead of the default github.io URL.

2) Netlify (drag-and-drop or Git)

- Drag-and-drop: zip the folder and drop it on https://app.netlify.com/drop to get an instant URL.
- Git: connect the repository on Netlify, set build command to empty (no build) and publish directory to `/`.

3) Vercel (Git)

- Import the repo into Vercel. It will detect a static site. Set Build & Output Settings: build command empty and output directory `/`.

Custom domain (CNAME)

- If you own a domain, create a `CNAME` file in the repo with the domain name (for GitHub Pages). Configure your DNS provider to point the domain to GitHub Pages or the provider-specific instructions for Netlify/Vercel.

Using `horizonsofavariceofficial.com` as your site domain

1) GitHub Pages

- Add the `CNAME` file at the repository root containing `horizonsofavariceofficial.com` (already added in this project).
- Push the repo and enable Pages from the `gh-pages` branch in repository Settings → Pages.
- In your DNS provider, create an A record pointing your root domain to GitHub Pages IP addresses (example set):
	- 185.199.108.153
	- 185.199.109.153
	- 185.199.110.153
	- 185.199.111.153

	Also add a CNAME record for the `www` subdomain pointing to `<your-username>.github.io` (or to the repository URL). Example:
	- Type: CNAME, Name: www, Value: <your-username>.github.io

	Note: DNS changes can take up to 48 hours to propagate. Once GitHub verifies the domain, your site will be available at https://horizonsofavariceofficial.com.

2) Netlify

- In Netlify, go to Site settings → Domain management → Add custom domain → enter `horizonsofavariceofficial.com`.
- Netlify will provide DNS instructions — typically a CNAME for `www` and an A record or ALIAS/ANAME for the root domain. Follow the exact records Netlify gives.

3) Vercel

- In Vercel, add the custom domain to your project and follow the provided DNS verification steps. Vercel will give the specific CNAME/A record values to configure.

Verify HTTPS

- Both GitHub Pages, Netlify, and Vercel offer automatic HTTPS with Let's Encrypt. After DNS propagates, enable or wait for automatic certificate issuance in the provider dashboard.

If you'd like I can:
- Generate exact PowerShell commands to push this project to a new GitHub repo and guide you through enabling Pages and verifying the custom domain.
- Or, if you give me access to your DNS provider (not recommended), I can instruct exact records to add.

Security & accessibility notes

- For improved accessibility, add ARIA attributes and ensure focus states and keyboard navigation are fully supported.
- For production forms, avoid client-side email sending — use a server endpoint or a provider (Formspree, Netlify Forms, etc.).

If you want, I can:
- Push this project to a new GitHub repository and configure the Pages workflow for you (you'll need to give me the repo name), or I can provide step-by-step commands to run locally.
- Configure a custom domain (you provide the domain and DNS access), or deploy to Netlify/Vercel and show the URL.

Contact form (send email)

1) Quick (no server) — Formspree

- Sign up at https://formspree.io and create a new form. Formspree will give you a POST endpoint like `https://formspree.io/f/abcd1234`.
- Open `index.html` and set that URL inside the `<form id="contactForm" data-endpoint="">` data-endpoint attribute.
- The site will POST the form to Formspree and Formspree will forward the submission to your email.

2) Server / custom backend

- If you prefer not to use Formspree, create a small server endpoint (Node/Express, serverless function, etc.) that accepts the POST and sends email (e.g., using Nodemailer or an API like SendGrid/Mailgun). Point the `data-endpoint` attribute at your endpoint URL and the form will POST there.
