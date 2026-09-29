# AI and Labour Market in Croatian Media

**Media Framing Analysis of Artificial Intelligence and Employment (2021–2026)**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![R 4.3+](https://img.shields.io/badge/R-%E2%89%A5%204.3-276DC3.svg)](https://cran.r-project.org/)
[![Quarto](https://img.shields.io/badge/Quarto-1.4+-75AADB.svg)](https://quarto.org/)

---

## Project Overview

This project analyzes Croatian media coverage of artificial intelligence and the labour market. The active working paper uses one Determ database spanning **68 consecutive months, January 2021–August 2026**. It selects items containing both AI-related and labour-market terms. Earlier exploratory analyses and Papers 2 and 3 use a shorter 2021–2023 extract.

The **active manuscript** is Paper 1, a descriptive study of coverage around ChatGPT's release. Papers 2 and 3 remain working drafts and future extensions.

The earlier Quarto analyses use the extraction and diagnostics scripts described below. The active working-paper edition has its own analysis and document-build scripts in `R/`.

---

## Exploratory Data Overview

The earlier descriptive analysis reports temporal patterns, frame prevalence, actor distributions, sentiment and outlet comparisons for the 2021–2023 extract. The active working paper uses the longer 68-month corpus.

| | Title | Code | Rendered report |
|---|-------|------|-----------------|
| **EDA** | AI and the Labour Market in Croatian Media -- Exploratory Analysis | [`03_analysis.qmd`](R/03_analysis.qmd) | [HTML report](https://raw.githack.com/lusiki/AI-and-labour_market/main/R/03_analysis.html) |

---

## Active manuscript

| Title | Download | Source |
|---|---|---|
| **After ChatGPT: Media Coverage of AI's Labour-Market Implications in Croatia** | [PDF](output/working-paper/ChatGPT_Croatia_Working_Paper.pdf?raw=1) · [Word](output/working-paper/ChatGPT_Croatia_Working_Paper.docx?raw=1) · [HTML](output/working-paper/ChatGPT_Croatia_Working_Paper.html?raw=1) | [Manuscript template](R/04_working_paper_template.md) · [analysis](R/04_working_paper_analysis.R) · [build script](R/04_build_working_paper.py) |

The PDF, Word and HTML links download the same working-paper edition. The [earlier Quarto draft](R/04_paper1_chatgpt_natural_experiment.qmd) is retained for project history and is superseded by this edition.

## Working drafts / future extensions

The two analyses below use the earlier 2021–2023 extract and are **not under active submission**. They are retained as starting points for follow-up work.

| # | Title | Code | Rendered report |
|---|-------|------|-----------------|
| P2 | AI Exposure and Media Salience Mismatch | [`05_paper2_occupation_exposure_mismatch.qmd`](R/05_paper2_occupation_exposure_mismatch.qmd) | [HTML report](https://raw.githack.com/lusiki/AI-and-labour_market/main/output/reports/05_paper2_occupation_exposure_mismatch.html) |
| P3 | Cross-Platform Narrative Propagation in AI Labour Coverage | [`06_paper3_cross_platform_cascades.qmd`](R/06_paper3_cross_platform_cascades.qmd) | [HTML report](https://raw.githack.com/lusiki/AI-and-labour_market/main/output/reports/06_paper3_cross_platform_cascades.html) |

---

## P1. After ChatGPT: Media Coverage of AI's Labour-Market Implications in Croatia

The paper analyzes 68 consecutive months from January 2021 through August 2026 in one Determ database. It reports monthly volume and lexical indicators, comparisons within named outlets, title similarity and recorded interactions. It treats the launch date as a descriptive reference because all outlets experience the event and there is no untreated comparison series.

The paper includes literature and measurement sections, platform and outlet breakdowns, chronology checks, model sensitivities, and a dictionary-validation protocol. Human validation of the indicators remains necessary before making stronger claims about frames or audience effects.

---

## Working draft details

The two subsections below describe Papers 2 and 3 as they currently stand. They are working drafts; methodology and conclusions may change before any future submission.

### P2. AI Exposure and Media Salience Mismatch

*Which Occupations Get the Narrative? Evidence from Croatian Digital Media*

This paper asks whether the occupations that dominate the Croatian AI--labour narrative are actually the ones most exposed to AI automation. The answer matters because if media systematically misrepresent which jobs face risk, workers receive distorted signals for retraining and career decisions.

**Occupation dictionary.** 30 occupations are constructed and classified along two dimensions. First, the Autor, Levy, and Murnane task taxonomy (routine cognitive, non-routine cognitive, routine manual, non-routine manual, creative/analytical). Second, a three-tier AI exposure rating (high, medium, low) derived from the Felten, Raj, and Seamans index and the Eloundou et al. GPT exposure scores. Croatian morphological variation is handled through stem-based regex patterns.

**Core contribution.** Each occupation receives a normalized media salience score (based on article mentions) and a normalized exposure score. The scatter plot of salience against exposure reveals which occupations are over-represented (high media attention, low actual exposure) and which are under-represented (high exposure, low attention). Spearman and Kendall rank correlations quantify the overall alignment.

**Additional analyses:**
- Logistic regressions testing whether occupation exposure tier predicts frame assignment (do high-exposure occupations trigger more job-loss framing?)
- Herfindahl--Hirschman Index tracking attention concentration over time
- Outlet-type comparisons showing whether tabloid and business outlets focus on different occupations

**Key next steps:**
- Link occupation dictionary to the Croatian NKZ classification mapped through ISCO codes (enabling continuous exposure scores)
- Validation exercise coding a random sample of occupation mentions for accuracy

---

### P3. Cross-Platform Narrative Propagation

*Information Cascades and Platform Heterogeneity in Croatian Digital Media*

This paper exploits the multi-platform structure of the corpus to study how AI--labour narratives move between web portals, Facebook, Twitter, YouTube, TikTok, Reddit, and forums. The economic question is whether platform structure creates systematic variation in the information environment, such that different audience segments receive different signals about AI and work.

**Platform fingerprints.** Chi-squared tests confirm that frame distributions are not platform-independent. A threat-to-opportunity ratio ranks platforms from most pessimistic to most optimistic.

**Core contribution.** A vector autoregression (VAR) is estimated on weekly platform-volume series. Augmented Dickey--Fuller tests check stationarity; first-differencing is applied where needed. Pairwise Granger causality tests at multiple lag orders identify which platforms lead and which follow. Results are visualized as a directed heatmap and a net information-flow score ranking platforms as net senders or receivers of narrative.

**Additional analyses:**
- Orthogonalized impulse response functions tracing how a shock to one platform propagates through the system over a 12-week horizon
- Forecast error variance decomposition quantifying what share of each platform's variation is attributable to other platforms
- Separate Granger tests on threat and opportunity frame shares to test whether framing *content* (not just volume) propagates directionally

**Key next steps:**
- Robustness checks on lag selection and sensitivity to weekly vs. biweekly aggregation
- Theoretical section connecting findings to the literature on media markets and information provision (Gentzkow and Shapiro 2010, Allcott and Gentzkow 2017)
- Test the editorial gatekeeping hypothesis: if web portals Granger-cause social media but not vice versa, the top-down model holds; the reverse would indicate bottom-up narrative generation

---

## Repository structure

```
AI-and-labour_market/
├── config.yml                 # Centralized parameters, paths, dictionaries
├── Makefile                   # Pipeline orchestration (make all / make clean)
├── Dockerfile                 # Reproducible compute environment
├── LICENSE                    # MIT license
├── CITATION.cff               # Machine-readable citation metadata
├── CONTRIBUTING.md            # Contribution guidelines
├── CODE_OF_CONDUCT.md         # Contributor Covenant
│
├── R/                         # Analysis scripts (run in order)
│   ├── 00_helpers.R           # Shared functions & config loader
│   ├── 01_extract_corpus.R    # Extract corpus from DuckDB
│   ├── 02_add_diagnostics.R   # Add keyword-match diagnostics
│   ├── 03_analysis.qmd        # Descriptive analysis (frames, actors, sentiment)
│   ├── 04_paper1_chatgpt_natural_experiment.qmd   # Earlier P1 draft
│   ├── 04_working_paper_analysis.R                # Active P1 analysis
│   ├── 04_working_paper_template.md               # Active P1 text
│   ├── 04_build_working_paper.py                  # HTML and Word build
│   ├── 05_paper2_occupation_exposure_mismatch.qmd # P2: Salience mismatch
│   └── 06_paper3_cross_platform_cascades.qmd      # P3: Platform cascades
│
├── data/
│   ├── raw/                   # Extracted corpus (.rds, git-ignored)
│   ├── processed/             # Diagnostic & analysed corpus (git-ignored)
│   └── codebook/              # Data dictionary & variable descriptions
│
├── output/
│   ├── figures/               # Publication-ready plots (git-ignored)
│   ├── tables/                # Summary tables (git-ignored)
│   ├── reports/               # Earlier rendered HTML reports
│   └── working-paper/         # Active P1 PDF, HTML and Word downloads
│
├── docs/                      # Project documentation
│   └── PROJECT_CONTEXT.md     # Detailed methodology & context
│
└── .github/
    └── workflows/
        └── ci.yml             # Lint & render check
```

## Shared data pipeline

```
DuckDB (~20M records)
    │
    ▼  SQL LIKE filter (fast, in-database)
    │
    ▼  Regex refinement (precise, in R)
    │
    ▼  01_extract_corpus.R
    │
data/raw/ai_labour_corpus.rds
    │
    ▼  02_add_diagnostics.R
    │
data/processed/ai_labour_corpus_diagnostic.rds
    │
    ├──▶ 03_analysis.qmd        → Descriptive report
    ├──▶ 04_paper1_*.qmd        → Earlier P1 draft
    ├──▶ 05_paper2_*.qmd        → P2: Occupation exposure mismatch
    └──▶ 06_paper3_*.qmd        → P3: Cross-platform cascades
```

## Quickstart

### Prerequisites

- **R >= 4.3** with packages listed in `R/00_helpers.R`
- **Quarto >= 1.4** (for rendering the earlier analysis reports)
- Python and Microsoft Word (for rebuilding the active working-paper downloads)
- Access to the Determ DuckDB database (for corpus extraction only)

### Run the pipeline

```bash
# Clone the repository
git clone https://github.com/lusiki/AI-and-labour_market.git
cd AI-and-labour_market

# Option A: use Make
make all            # runs the earlier Quarto pipeline

# Option B: run scripts manually
Rscript R/01_extract_corpus.R       # extract corpus from DuckDB
Rscript R/02_add_diagnostics.R      # add diagnostic columns
quarto render R/03_analysis.qmd     # descriptive analysis
quarto render R/04_paper1_chatgpt_natural_experiment.qmd # earlier P1 draft
quarto render R/05_paper2_occupation_exposure_mismatch.qmd
quarto render R/06_paper3_cross_platform_cascades.qmd

# Render individual earlier Quarto papers
make paper1         # earlier P1 draft
make paper2         # P2 only
make paper3         # P3 only
```

To rebuild the active P1 edition after preparing its extended corpus and analysis dependencies, run `R/04_working_paper_analysis.R`, `python R/04_build_working_paper.py`, then `R/04_export_working_paper.ps1` in PowerShell. The downloaded files above are already built; the proprietary corpus is not in Git.

### Using Docker

```bash
docker build -t ai-labour .
docker run --rm -v "$(pwd)/output:/app/output" ai-labour
```

## Data access

The raw data files (`.rds`) are **not included** in this repository due to size (~300 MB) and licensing constraints. The Determ media-monitoring database is proprietary.

**To reproduce from scratch:**
1. Obtain access to the Determ DuckDB database
2. Update `config.yml` with the database path
3. Run `Rscript R/01_extract_corpus.R`

**To work with pre-processed data:**
Contact the authors for access to anonymized or aggregated datasets suitable for replication.

## Configuration

All parameters -- file paths, keyword dictionaries, frame definitions, actor lists, event timelines, and analysis thresholds -- are defined in [`config.yml`](config.yml). Scripts read this file via `R/00_helpers.R`, so no paths are hardcoded in the analysis code.

## Methodology

### Corpus extraction

Two-stage intersection filter: SQL `LIKE` patterns for speed, followed by precise regex matching in R to handle Croatian morphological variation (7-case noun system, verb conjugations, adjective agreement). An article enters the corpus only if it contains at least one term from Group A (AI/technology, 15 patterns) AND at least one from Group B (labour market, 15 patterns).

### Frame analysis

Dictionary-based detection using curated keyword lists for eight interpretive frames:

| Frame | Description |
|-------|-------------|
| `JOB_LOSS` | AI eliminates jobs |
| `JOB_CREATION` | AI creates new opportunities |
| `TRANSFORMATION` | AI transforms rather than destroys work |
| `SKILLS` | Focus on reskilling and education |
| `REGULATION` | Policy, governance, and worker protection |
| `PRODUCTIVITY` | Economic benefits and efficiency |
| `INEQUALITY` | Distributional concerns and digital divide |
| `FEAR_RESISTANCE` | Anxiety, fear, and opposition to AI |

### Actor analysis

Keyword-based identification of six stakeholder categories: Workers, Employers, Tech Companies, Policy Makers, Experts, and Unions.

### Outlet classification

Croatian media sources classified into six types: Tabloid, Quality, Regional, Public, Tech, and Business.

See [`docs/PROJECT_CONTEXT.md`](docs/PROJECT_CONTEXT.md) for full methodological details including keyword lists and Croatian language considerations.

## Citation

If you use this code or methodology, please cite:

```bibtex
@software{sikic2024ailabour,
  author    = {Sikic, Luka},
  title     = {AI and the Labour Market in Croatian Media: A Framing Analysis},
  year      = {2024},
  url       = {https://github.com/lusiki/AI-and-labour_market}
}
```

See also [`CITATION.cff`](CITATION.cff) for machine-readable citation metadata.

## License

This project is licensed under the [MIT License](LICENSE). The underlying media data is subject to Determ's terms of service and is not redistributed.

## Contributing

Contributions are welcome. Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for guidelines.
