# Wingman — Team degli Agenti

Architettura multi-board con Wingman come autorità suprema.
**49 profile totali**: 52 markdown per board (4 dispatcher + 40 atomici) + 5 cross/global (claude-delegate, consistency-keeper, recruiter, curator, summarizer) + Wingman + client-dispatcher — assunti dai migliori repo pubblici.

> **Nota architetturale**: curator e summarizer sono profile GLOBALI (1 ciascuno), non per-board. Vengono referenziati via `assignee curator` / `assignee summarizer` da qualsiasi board. I 4 dispatcher sono embedded nei profile base di ciascun board.


## Architettura Deploy Siti Cliente

| Tipo | Hosting | CI/CD | URL pattern |
|------|---------|-------|-------------|
| Demo lead | CF Pages direct upload | pipeline wrangler CLI | `{slug}.coreflux.studio` |
| Cliente acquista | CF Worker | GitHub repo Hypn0sis/{slug} + CF dashboard | dominio cliente |
| Portfolio agency | CF Worker (core-agency) | push su `~/wingman/` = auto-deploy | `coreflux.studio` |

**Sito portfolio** = `~/wingman/` clone di `Hypn0sis/core-agency` — push su master deploya su `coreflux.studio`.

## Struttura

```
wingman/
├── AGENTS.md              ← questo file (indice generale)
├── wingman.md             ← Wingman (comandante supremo, unico interlocutore)
├── clients/
│   └── dispatcher.md      ← Client Dispatcher (ingresso clienti, dispatch ai board)
└── boards/
    ├── sviluppo/          ← 17 markdown (dispatcher + curator + summarizer + 14 atomici)
    ├── marketing/         ← 12 markdown (dispatcher + curator + summarizer + 9 atomici)
    ├── admin/             ← 10 markdown (dispatcher + curator + summarizer + 7 atomici)
    └── sales/             ← 13 markdown (dispatcher + curator + summarizer + 10 atomici)
```

## Legenda ruoli per board

Ogni board ha:
- **Dispatcher** — smista richieste all'agente atomico giusto
- **Curator** — revisiona qualità, mantiene documentazione, ordine repository
- **Summarizer** — riassume attività del board per Wingman e altri board
- **Agenti atomici** — uno per funzione, tecnologia-agnostici

## Board SVILUPPO (17 agenti)

| Agente | Ruolo | Ispirato da |
|--------|-------|-------------|
| dispatcher | Routing richieste | awesome-claude-code-subagents |
| curator | Qualità codice + docs + repo hygiene | ECC react-reviewer framework |
| summarizer | Riepilogo attività | custom |
| asset-auditor | Inventario asset sito cliente (logo, tel, orari, social, P.IVA); salva manifest in vault-cliente; PRIMO in catena TEMPLATE-FAST e DESIGN-HEAVY | custom |
| architect | Architettura sistema, ADR, dependency graph | awesome-claude-code-toolkit (frontend-architect) |
| builder | Implementazione feature | awesome-claude-code-toolkit (developer) |
| reviewer | Code review, bug detection, security | ECC (react-reviewer, multi-reviewers) |
| tester | Test strategy, unit, integration, e2e | VoltAgent subagents pattern |
| integrator | API third-party, webhooks, middleware | awesome-claude-code-toolkit |
| optimizer | Performance audit, caching, bundle | awesome-claude-code-toolkit |
| design-system-architect | Design tokens (palette, typography, spacing), component primitives | awesome-claude-code-toolkit (frontend-architect), shadcn/ui |
| ui-ux-expert | Information architecture, wireframe, user flow, interaction patterns | awesome-claude-code-toolkit (ux-designer), 21st.dev, Refactoring UI |
| motion-designer | Micro-interaction, transition, scroll animation, performance budget | Framer Motion docs, Aceternity UI, GSAP |
| a11y-auditor | WCAG 2.2 AA audit, semantic HTML, contrast, keyboard, screen-reader | axe-core, WCAG 2.2, Deque |
| data-modeler | Schema, types, data flow, state | custom |
| docs-writer | API docs, setup guide, changelog | awesome-claude-code-toolkit (technical-writer) |
| ops | CI/CD, build, deploy, infra | awesome-claude-code-toolkit + ECC |

## Board MARKETING (12 agenti)

| Agente | Ruolo | Ispirato da |
|--------|-------|-------------|
| dispatcher | Routing richieste | custom |
| curator | Qualità contenuti + docs + repo hygiene | custom |
| summarizer | Riepilogo attività | custom |
| strategist | Posizionamento, audience, piano editoriale | awesome-claude-code-toolkit (content-strategist) |
| copywriter | Testi per post, email, landing page, ads | ECC (marketing-agent) |
| visual-creator | Immagini, video, grafiche | custom |
| publisher | Pubblicazione e scheduling contenuti | custom |
| scheduler | Calendario editoriale, timing | custom |
| analyst-marketing | Metriche, KPI, engagement, ROI | awesome-claude-code-toolkit (marketing-analyst) |
| seo-specialist | Keyword research, on-page, structured data | awesome-claude-code-toolkit + VoltAgent |
| community-manager | Gestione interazioni social | VoltAgent subagents pattern |
| docs-writer | Tone of voice, playbook, strategie | awesome-claude-code-toolkit (technical-writer) |

## Board ADMIN (10 agenti)

| Agente | Ruolo | Ispirato da |
|--------|-------|-------------|
| dispatcher | Routing richieste | custom |
| curator | Qualità processi + docs + repo hygiene | custom |
| summarizer | Riepilogo attività | custom |
| compliance-check | Privacy, TOS, licenze, normative | awesome-claude-code-toolkit (legal-advisor) |
| billing-officer | Fatturazione, pagamenti, abbonamenti | custom |
| contract-manager | Redazione, archiviazione, tracking contratti | custom |
| asset-keeper | Credenziali, domini, licenze, SaaS | custom |
| onboarder | Presa in carico nuovi clienti | awesome-claude-code-toolkit (customer-success) |
| reporter | Report finanziari, KPI business | custom |
| docs-writer | Procedure, policy, template | awesome-claude-code-toolkit (technical-writer) |

## Board SALES (13 agenti)

| Agente | Ruolo | Ispirato da |
|--------|-------|-------------|
| dispatcher | Routing richieste | custom |
| curator | Qualità proposte + docs + repo hygiene | custom |
| summarizer | Riepilogo attività | custom |
| prospector | Lead generation, qualifica BANT, outreach | custom |
| competitor-analyst | Monitoraggio competitor, battle cards | VoltAgent + awesome-claude-code-toolkit |
| negotiator | Trattativa, obiezioni, counter-offer | custom |
| pricing-manager | Scontistica, pacchetti, revenue optimization | custom |
| proposal-writer | Preventivi, proposte, pitch deck | awesome-claude-code-toolkit (sales-engineer) |
| crm-keeper | Pipeline, data quality, follow-up | awesome-claude-code-toolkit (customer-success) |
| revenue-tracker | MRR/ARR, forecast, trend | custom |
| collections-agent | Solleciti, morosi, piani di rientro | custom |
| account-manager | Post-vendita, retention, upsell, QBR | awesome-claude-code-toolkit (customer-success) |
| docs-writer | Playbook, script, battle cards, pricing history | awesome-claude-code-toolkit (technical-writer) |

## Cross-Board Profiles (5)

| Profile | Ruolo | Ispirato da |
|---------|-------|-------------|
| claude-delegate | Orchestrator per task complessi cliente-facing; coordina catene multi-board | custom |
| consistency-keeper | Audit coerenza tra documentazione, profile SOUL, vault, specs, repo git | custom |
| recruiter | Matching profilo cliente → board/atomic; nomina agent candidati per task | custom |
| curator | Revisione qualità cross-board; mantiene documentazione; ordina repository | ECC react-reviewer framework |
| summarizer | Riassume attività board per Wingman; spillover inter-board | custom |

## Formato agenti

Ogni agente usa YAML frontmatter + markdown, formato compatibile con Claude Code, Codex CLI e Hermes:
```yaml
---
name: architect
description: Definisce architettura del sistema, struttura del progetto, dependency graph
board: sviluppo
type: atomic
model: opus
tools: [Read, Write, Edit, Bash, Glob, Grep]
---
```

## Repo di riferimento

| Repo | Stelle | Agenti | Cosa abbiamo preso |
|------|--------|--------|--------------------|
| rohitg00/awesome-claude-code-toolkit | 2.1k⭐ | 135 | frontend-architect, marketing, sales pattern, YAML format |
| VoltAgent/awesome-claude-code-subagents | - | 129 | Dispatcher pattern, 14 categories, agent structure |
| affaan-m/ECC | 215k⭐ | 62 | Detailed role definitions, react-reviewer framework |
| x1xhlol/system-prompts | 140k⭐ | 30+ | Reference system prompts structure |
