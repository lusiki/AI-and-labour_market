# CLAUDE.md — AI & Labour Market in Croatian Media

## What this repo is
Media-framing analysis of how Croatian digital media (2021–2024) covered AI and the labour market. Corpus is built from the proprietary Determ database (~20M records) via a two-stage SQL `LIKE` + regex intersection filter (AI term AND labour term). One descriptive EDA + three standalone economics papers share the same corpus.

## Authoritative references — read these before answering methodology questions
- `README.md` — project scope, paper abstracts, repo layout
- `docs/PROJECT_CONTEXT.md` — full methodology, keyword lists, Croatian language notes
- `data/codebook/codebook.md` — variable definitions
- `config.yml` — paths, SQL/regex patterns, frame dictionaries, actor lists, outlet classifications

Do not re-derive what these documents already specify. If the user asks a methodology question, consult them first.

## Pipeline contract
```
01_extract_corpus.R  →  data/raw/ai_labour_corpus.rds
02_add_diagnostics.R →  data/processed/ai_labour_corpus_diagnostic.rds
03_analysis.qmd      →  output/reports/03_analysis.html        (EDA)
04_paper1_*.qmd      →  output/reports/04_paper1_*.html        (ChatGPT event study)
05_paper2_*.qmd      →  output/reports/05_paper2_*.html        (occupation/exposure)
06_paper3_*.qmd      →  output/reports/06_paper3_*.html        (cross-platform cascades)
```
Step 01 needs the Determ DuckDB and is rarely re-run. Steps 02→06 are the everyday loop.

## How to run things
- Full pipeline: `make all`
- Single paper: `make paper1` / `paper2` / `paper3`
- Clean intermediates (keeps raw): `make clean`
- Manual render: `quarto render R/<file>.qmd --output-dir ../output/reports`

The Makefile is the source of truth for commands — prefer `make` targets over typing `Rscript` / `quarto render` directly.

## Hard rules
- **Never edit `data/raw/*`.** It is the immutable extract.
- **Never hardcode paths, regex, frames, or keyword lists in scripts.** They live in `config.yml` and are loaded via `R/00_helpers.R`.
- **Never commit anything in `output/figures/`, `output/tables/`, `data/raw/`, or `data/processed/`** — all gitignored. Only `output/reports/*.html` is shared (via raw.githack links in README).
- **Don't add `02b_*` or `03_extra_*` scripts.** Either extend the next-numbered slot or refactor into `00_helpers.R`.
- **Don't introduce a new dependency** (R package, tool) without flagging it — the Dockerfile pins the environment.

## Path resolution gotcha (already fixed — don't break it)
QMDs in `R/` source helpers as `source("00_helpers.R")`, NOT `source("R/00_helpers.R")`. `R/00_helpers.R` auto-detects `PROJECT_ROOT` by looking for `config.yml` in `.` or `..`, so scripts work from either the project root or `R/`. If you see a path bug, fix it in `00_helpers.R`'s detection logic, not by hardcoding paths in QMDs. (See commits `5dfca24`, `c34fa4e`.)

## Reproducibility
Environment is pinned in `Dockerfile`. No `renv.lock`, no `.Rproj` — by design. Don't add them.

## Out of scope for me to touch
`LICENSE`, `CITATION.cff`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `.github/workflows/ci.yml` — leave alone unless explicitly asked.
