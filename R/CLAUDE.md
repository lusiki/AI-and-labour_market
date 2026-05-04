# R/ — pipeline conventions

## Sourcing helpers
At the top of every script and QMD chunk:
```r
source("00_helpers.R")   # NOT "R/00_helpers.R"
```
`00_helpers.R` auto-detects `PROJECT_ROOT` (looks for `config.yml` in `.` or `..`), exports `path_*` variables, ensures output dirs exist, and provides `load_packages()`, `build_combined_regex()`, `build_sql_or()`, `find_matches_and_context()`, `log_step()`. Reuse these — don't re-implement.

## Numbered-script discipline
Scripts run in order: `00 → 01 → 02 → 03 → 04 → 05 → 06`. Don't insert `02b_*` or `03_extra_*`. If a step needs more code, either:
1. Extend the existing numbered file, or
2. Promote shared logic into `00_helpers.R`.

A new analytical angle = a new top-level numbered slot, agreed with the user first.

## Configuration is centralized
Frame dictionaries, regex patterns, SQL `LIKE` terms, actor lists, outlet classifications, event dates, analysis thresholds — all live in `config.yml`. Read via `CONFIG$<section>$<key>`. **Never hardcode** any of these in the R/QMD layer.

## Quarto rendering
QMDs render from inside `R/`. Output dir is `../output/reports/` (relative to `R/`). The Makefile already handles `--output-dir` correctly — match its pattern if adding new render commands.

## Packages
Loaded inside each script via `load_packages(c(...))`. If you need a new package, add it where it's used and flag the addition — it must also work inside the Dockerfile environment.
