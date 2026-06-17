# Codebase scan protocol — resumable, multi-session deep read

For large/unfamiliar repos. Designed to survive context limits and span sessions without
losing progress or re-reading what's already understood.

## Artifacts (the resumable state)

Everything lives under `docs/ai-bootstrap/` in the target repo:

```
docs/ai-bootstrap/
  scan-progress.md          # the LEDGER — the single source of "what's done"
  findings/<area>.md        # one accumulating note per area
  handoff.md                # latest session handoff (overwritten each session end)
```

### The ledger — `scan-progress.md`

```markdown
# Scan progress — <project>
Started: <YYYY-MM-DD>   |   Last session: <YYYY-MM-DD>
Overall: <N> areas, <M> scanned, <K> pending

## Areas
| # | Area / path | Priority | Status | Findings file | Notes |
|---|---|---|---|---|---|
| 1 | build & manifests (root) | P0 | scanned  | findings/00-build.md | poetry, ruff, mypy |
| 2 | src/api            | P0 | scanned  | findings/api.md      | FastAPI routers |
| 3 | src/services       | P0 | pending  | —                   | |
| 4 | src/db             | P1 | pending  | —                   | |
| 5 | tests              | P1 | pending  | —                   | |
| 6 | external refs/deps | P2 | pending  | —                   | submodules, vendored libs |
```

Status values: `pending` → `in-progress` → `scanned`. Only one row `in-progress` at a time.

## Procedure

### Session start (every time)
1. Does `docs/ai-bootstrap/scan-progress.md` exist?
   - **Yes** → read it + the latest `handoff.md`. **Resume from the first `pending` (or
     `in-progress`) area.** Do not re-scan `scanned` areas.
   - **No** → this is session 1. Go to "Bootstrap the ledger".

### Bootstrap the ledger (session 1 only)
1. Read top-level layout and manifests first — package/build files, lockfiles, CI config,
   Makefile, Dockerfiles, monorepo config. These reveal stack, commands, and module boundaries
   cheaply.
2. List the top-level source areas and external references (submodules, vendored deps,
   generated code).
3. Write the ledger: one row per area. Prioritize by **dependency centrality** —
   entry points and core domain first (P0), supporting layers next (P1), peripheral/vendored
   last (P2).

### Scan one area
1. Flip its row to `in-progress`.
2. Read it with intent — for a large area, **delegate to an Explore subagent** with a focused
   brief ("map src/services: public entry points, data models, error handling, external calls,
   naming/style conventions; return conclusions, not file contents"). Use up to a few agents
   in parallel for independent areas.
3. Append to `findings/<area>.md`:
   - purpose & public entry points,
   - key data models / types,
   - external integrations & references,
   - **observed conventions** (naming, error handling, logging, async, tests) with 1–2 quoted
     examples,
   - build/test facts specific to this area,
   - open questions.
4. Flip the row to `scanned` with a one-line note.

### Budget & stopping
- Keep each area's findings tight — conclusions and representative snippets, not transcripts.
- When context gets heavy or the session is ending, **stop at an area boundary** (never
  mid-area with the row left `in-progress` and no notes).

### Session end (every time)
Write `docs/ai-bootstrap/handoff.md`:

```markdown
# Scan handoff — <YYYY-MM-DD>
Scanned this session: <areas>
Next up: <first pending area> — <why / what to look for>
Open questions so far: <list>
Resume by: reading scan-progress.md, then findings/, then continuing the ledger.
```

Also persist a one-line pointer to memory if the harness supports it, so a future session
knows a scan is in flight.

## When the scan is complete
Every area `scanned` (or user-accepted partial scope, recorded in the ledger). Then return to
`existing-project.md` §2 to synthesize the TRD from `findings/`.

> Keep `docs/ai-bootstrap/` in the repo (or gitignore it) per the user's preference — it is
> working state, not part of the delivered framework. Ask if unsure.
