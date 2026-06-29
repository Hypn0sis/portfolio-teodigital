# COREFLUX WINGMAN — Release Notes

## v1.0.0 — June 29, 2026

**Status**: Stable — Production Ready

### Features

- ✓ Multi-agent system (49 profiles, 4 boards)
- ✓ Portfolio + branding (15 category-style templates)
- ✓ Sales pipeline orchestration (autonomous lead-to-hookmail)
- ✓ Email outreach (Brevo SMTP, finalized copy)
- ✓ Template token injection system ({{}} for LLM)
- ✓ Cloudflare Pages deployment (automatic wrangler CLI)

### Key Assets

- **AGENTS.md** — Complete agent inventory + role descriptions
- **CLAUDE.md** — System context, pricing (V2), workflows, dogmas
- **sales-pipeline-runner.md** — Lead pipeline orchestration (STEP 1-9)
- **hookmail_body.py** — Finalized email body (story-driven, no discount)
- **Templates** — 15 active portfolio templates (alimentari, bellezza, moda, ristorazione, servizi)

### Infrastructure

- **Portfolio**: CF Worker + GitHub (Hypn0sis/core-agency)
- **Deploy**: Automatic on git push to master
- **Email**: Brevo SMTP (SPF-aligned, no Gmail API)
- **Vaults**: 6 sub-repos (global-knowledge, sales, admin, marketing, cliente, sviluppo)

### Breaking Changes

None — first release

### Known Issues

- Templates: 15/30 built (50% toward goal)
- Cross-board profiles documentation clarified (3 files + 2 global-only)

### Next Release

**v1.5.0** — Phase 1 Templates Complete
- Target: +8 templates (25 total)
- Timeline: Week 3 of template build

**v2.0.0** — All 30 Templates + New Categories
- Target: +15 templates (30 total)
- Timeline: Week 5 of template build

---

## Versioning

**Format**: Semantic Versioning (MAJOR.MINOR.PATCH)

- **MAJOR** (v2.0.0): Feature categories added (>15 templates per major release)
- **MINOR** (v1.1.0): Workflow improvements, bug fixes, docs
- **PATCH** (v1.0.1): Hotfixes, minor content updates

---

## Installation & Setup

```bash
# Clone portfolio repo
git clone https://github.com/Hypn0sis/core-agency.git ~/wingman

# Setup vaults (separate git repos)
cd ~/wingman
for vault in global-knowledge sales admin marketing cliente sviluppo; do
  git clone https://github.com/hypnosis/vault-$vault vault-$vault
done

# Install dependencies
pip install -r requirements.txt  # If applicable
npm install  # For wrangler

# Deploy portfolio
git push origin master  # Auto-deploys to coreflux.studio
```

---

## Support & Issues

Report issues: <https://github.com/Hypn0sis/core-agency/issues>

Contact: Teo <info@coreflux.studio>
