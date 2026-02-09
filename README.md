# AI and the Labour Market in Croatian Media

**Media Framing Analysis of Artificial Intelligence and Employment (2021--2024)**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![R 4.3+](https://img.shields.io/badge/R-%E2%89%A5%204.3-276DC3.svg)](https://cran.r-project.org/)
[![Quarto](https://img.shields.io/badge/Quarto-1.4+-75AADB.svg)](https://quarto.org/)

---

## Overview

This repository contains the data-processing pipeline and analytical code for a study of how Croatian digital media frame the intersection of **artificial intelligence** and the **labour market**. The corpus is drawn from the [Determ](https://www.determ.com/) media-monitoring platform (~20 million records, Jan 2021 -- May 2024) and filtered to articles that mention both AI-related and labour-market-related terms (intersection logic: Group A &cap; Group B).

The project includes a **shared data pipeline** and **three research papers**, each targeting publication in an economics journal.

## Papers

| # | Script | Title |
|---|--------|-------|
| Paper 1 | `R/04_paper1_chatgpt_natural_experiment.qmd` | The ChatGPT Shock and Media Framing of AI Labour Displacement: An Event Study Approach |
| Paper 2 | `R/05_paper2_occupation_exposure_mismatch.qmd` | AI Exposure and Media Salience Mismatch: Which Occupations Get the Narrative? |
| Paper 3 | `R/06_paper3_cross_platform_cascades.qmd` | Cross-Platform Narrative Propagation in AI Labour Coverage: Information Cascades and Platform Heterogeneity |

## Research questions

| # | Question |
|---|----------|
| RQ1 | How much media coverage does the AI--labour nexus receive, and how has it evolved? |
| RQ2 | Which interpretive frames dominate, and how has their prevalence shifted? |
| RQ3 | Whose perspectives appear most frequently? |
| RQ4 | Do different media outlet types frame the topic differently? |

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
│   ├── 04_paper1_chatgpt_natural_experiment.qmd
│   ├── 05_paper2_occupation_exposure_mismatch.qmd
│   └── 06_paper3_cross_platform_cascades.qmd
│
├── data/
│   ├── raw/                   # Extracted corpus (.rds, git-ignored)
│   ├── processed/             # Diagnostic & analysed corpus (git-ignored)
│   └── codebook/              # Data dictionary & variable descriptions
│
├── output/
│   ├── figures/               # Publication-ready plots (git-ignored)
│   ├── tables/                # Summary tables (git-ignored)
│   └── reports/               # Rendered HTML/PDF reports (git-ignored)
│
├── docs/                      # Project documentation
│   └── PROJECT_CONTEXT.md     # Detailed methodology & context
│
└── .github/
    └── workflows/
        └── ci.yml             # Lint & render check
```

## Quickstart

### Prerequisites

- **R >= 4.3** with packages listed in `R/00_helpers.R`
- **Quarto >= 1.4** (for rendering the analysis reports)
- Access to the Determ DuckDB database (for corpus extraction only)

### Run the pipeline

```bash
# Clone the repository
git clone https://github.com/lusiki/AI-and-labour_market.git
cd AI-and-labour_market

# Option A: use Make
make all            # runs steps 01 → 02 → 03 + papers in sequence

# Option B: run scripts manually
Rscript R/01_extract_corpus.R       # extract corpus from DuckDB
Rscript R/02_add_diagnostics.R      # add diagnostic columns
quarto render R/03_analysis.qmd     # descriptive analysis
quarto render R/04_paper1_chatgpt_natural_experiment.qmd
quarto render R/05_paper2_occupation_exposure_mismatch.qmd
quarto render R/06_paper3_cross_platform_cascades.qmd
```

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

All parameters -- file paths, keyword dictionaries, frame definitions, actor lists, event timelines, and analysis thresholds -- are defined in `config.yml`. Scripts read this file via `R/00_helpers.R`, so no paths are hardcoded in the analysis code.

## Methodology

1. **Two-stage corpus extraction**: SQL `LIKE` filters for speed, followed by precise regex matching in R to handle Croatian morphological variation (7-case noun system, verb conjugations, adjective agreement).

2. **Frame analysis**: Dictionary-based detection using curated keyword lists for eight interpretive frames drawn from the media framing literature.

3. **Actor analysis**: Keyword-based identification of six stakeholder categories.

4. **Temporal analysis**: Monthly volume trends, LOESS smoothing, and event-anchored markers (ChatGPT launch, GPT-4 release, EU AI Act adoption).

5. **Outlet comparison**: Classification of Croatian media sources into six types (Tabloid, Quality, Regional, Public, Tech, Business).

See [`docs/PROJECT_CONTEXT.md`](docs/PROJECT_CONTEXT.md) for full methodological details.

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
