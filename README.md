# visual-first-design

**A visual-first framework for agentic development and agent-driven CI/CD.**

The premise: in agent-driven development, the human steering the pipeline is often a product manager or a technical non-developer. They cannot review a diff — and asking them to is a rubber stamp with latency. They can review a screen. So this framework makes the **rendered deliverable** — mock, screenshots, before/after pair, live proof — the unit of review at every pipeline stage, and makes fabricated or missing evidence a first-class, machine-checkable failure.

This inverts the default agent workflow. Agents review code; the human reviews consequences, from a phone, in under two minutes per gate.

## The visual contract

| Stage | Visual artifact | Gate question |
|---|---|---|
| **Intent** | 2–3 labeled mock options, BEFORE any code | "Is this what you meant?" |
| **Build** | Screenshots at 390px + 1280px from the running result | "Does it look right?" |
| **Change** | Before/after pair, same viewport, same scroll | "Is after better?" |
| **Deploy** | Live URL + capture from the deployed surface | "Is it really live?" |
| **Done** | Completion report: visuals first, plain language, clickable paths | "Anything left for me?" |

## Components

| Component | Type | What it does |
|---|---|---|
| `visual-first-design-skill` | knowledge skill (auto-triggers) | The core methodology: the contract, evidence rules, rationalization counters, red flags |
| `/mock-first` | workflow skill | Renders 2–3 real-brand mock options at 390px before implementation starts |
| `/visual-gate` | workflow skill | Captures the stage evidence — before/after pairs at both viewports — and writes a verifiable manifest |
| `/visual-report` | workflow skill | Composes the completion report in the contract shape, verifying every artifact on disk first |
| `visual-evidence-reviewer` | agent | Adversarial CI/CD reviewer: fails a change whose evidence is missing, stale, fabricated, or unreachable |

Evidence lives in `visual-evidence/<change-slug>/` on the branch, so it rides with the PR and both humans and reviewer agents can reach it.

## Install

**Claude Code (plugin):**

```bash
claude --plugin-dir /path/to/visual-first-design
```

or add the repo to your marketplace configuration. When loaded as a plugin, the workflow skills are namespaced — `/visual-first-design:mock-first` — while the `~/.agents/skills` install below exposes them bare (`/mock-first`).

**Other engines (Codex, Gemini, Copilot CLI — anything reading `~/.agents/skills/`):**

```bash
cd /path/to/visual-first-design && bash scripts/install.sh
```

```powershell
cd C:\path\to\visual-first-design; powershell -File scripts\install.ps1
```

The install scripts copy the four skills into `~/.agents/skills/` with a provenance header pointing back at this repo — refresh from here, never edit the copies. Engines without a skills directory (Hermes, Kimi, DeepSeek in raw harnesses): paste `skills/visual-first-design-skill/SKILL.md` into the agent's instruction surface (`AGENTS.md` or equivalent); it is self-contained.

**Screenshot capability:** any browser tool the engine has. Universal fallback used throughout, works anywhere with Node:

```bash
npx playwright screenshot --viewport-size=390,844 --full-page "$URL" out.png
```

## Quickstart

1. Operator asks for a visible change → `/mock-first <the request>` → operator picks a mock from their phone.
2. Agent builds the picked option → `/visual-gate` → before/after pairs captured and committed.
3. `visual-evidence-reviewer` audits the branch → PASS required to merge.
4. Deploy → `/visual-gate <live-url>` adds live captures → `/visual-report` → operator reads visuals-first report.

## Why "visual-first" and not "screenshot at the end"

End-only visuals surface direction errors after the build is paid for. The intent mock costs minutes and moves the operator's steering to the cheapest possible moment. The before/after pair is what makes a two-minute phone review real. The reviewer agent's existence check is what makes "screenshot attached" mean something — in baseline testing for this framework, an unprompted agent under deadline pressure fabricated a screenshot reference with zero tool calls. That failure class is why the evidence chain is verified, not trusted.

## Roadmap

- **v0.2 — machine gate:** a Stop/pre-merge hook that blocks completion claims when `visual-evidence/` is missing or stale (enforce in the pipeline, not in instructions)
- CI templates (GitHub Actions) running the reviewer agent on every PR touching visible surfaces
- Visual diff tooling (pixel-level before/after highlighting)

## License

MIT
