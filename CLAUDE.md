# CLAUDE.md — AI & Labour Market in Croatian Media

## What this repo is
Media-framing analysis of Croatian coverage of AI and the labour market. The final Paper 1 working-paper edition covers 68 consecutive months, January 2021–August 2026, in one Determ database. The earlier descriptive analysis and Papers 2–3 use a shorter extract.

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
04_working_paper_analysis.R + 04_build_working_paper.py
                     →  output/working-paper/ChatGPT_Croatia_Working_Paper.{html,docx}
04_export_working_paper.ps1
                     →  output/working-paper/ChatGPT_Croatia_Working_Paper.pdf
05_paper2_*.qmd      →  output/reports/05_paper2_*.html        (occupation/exposure)
06_paper3_*.qmd      →  output/reports/06_paper3_*.html        (cross-platform cascades)
```
Paper 1 uses the extended corpus and its own build scripts. The earlier exploratory and Paper 2–3 pipeline remains separate.

## How to run things
- Earlier pipeline plus paper targets: `make all`
- Single paper: `make paper1` / `paper2` / `paper3`; Paper 1 PDF export requires Windows with Microsoft Word
- Clean intermediates (keeps raw): `make clean`
- Manual render: `quarto render R/<file>.qmd --output-dir ../output/reports`

The Makefile is the source of truth for commands — prefer `make` targets over typing `Rscript` / `quarto render` directly.

## Hard rules
- **Never edit `data/raw/*`.** It is the immutable extract.
- **Never hardcode paths, regex, frames, or keyword lists in scripts.** They live in `config.yml` and are loaded via `R/00_helpers.R`.
- **Never commit anything in `output/figures/`, `output/tables/`, `data/raw/`, or `data/processed/`** — all gitignored. The final Paper 1 PDF, HTML and Word files in `output/working-paper/` are tracked for download.
- **Don't add `02b_*` or `03_extra_*` scripts.** Either extend the next-numbered slot or refactor into `00_helpers.R`.
- **Don't introduce a new dependency** (R package, tool) without flagging it — the Dockerfile pins the environment.

## Path resolution gotcha (already fixed — don't break it)
QMDs in `R/` source helpers as `source("00_helpers.R")`, NOT `source("R/00_helpers.R")`. `R/00_helpers.R` auto-detects `PROJECT_ROOT` by looking for `config.yml` in `.` or `..`, so scripts work from either the project root or `R/`. If you see a path bug, fix it in `00_helpers.R`'s detection logic, not by hardcoding paths in QMDs. (See commits `5dfca24`, `c34fa4e`.)

## Reproducibility
Environment is pinned in `Dockerfile`. No `renv.lock`, no `.Rproj` — by design. Don't add them.

## Out of scope for me to touch
`LICENSE`, `CITATION.cff`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `.github/workflows/ci.yml` — leave alone unless explicitly asked.
