# ==============================================================================
# Makefile — AI & Labour Market Media Analysis Pipeline
# ==============================================================================
# Usage:
#   make all       Run the full pipeline (extract → diagnose → analyse → papers)
#   make extract   Step 1 only (requires DuckDB access)
#   make diagnose  Step 2 only
#   make report    Descriptive analysis only
#   make papers    Render all three research papers
#   make clean     Remove generated outputs
#   make help      Show this help
# ==============================================================================

.PHONY: all extract diagnose report papers paper1 paper2 paper3 clean clean-all help

RSCRIPT := Rscript --vanilla
QUARTO  := quarto render

# Output files
RAW_CORPUS  := data/raw/ai_labour_corpus.rds
RAW_CORPUS_EXT := data/raw/ai_labour_corpus_2021_2026.rds
DIAG_CORPUS := data/processed/ai_labour_corpus_diagnostic.rds
REPORT_HTML := output/reports/03_analysis.html
PAPER1_PDF  := output/working-paper/ChatGPT_Croatia_Working_Paper.pdf
PAPER2_HTML := output/reports/05_paper2_occupation_exposure_mismatch.html
PAPER3_HTML := output/reports/06_paper3_cross_platform_cascades.html

# ==============================================================================
# Pipeline targets
# ==============================================================================

all: $(REPORT_HTML) papers  ## Run the full pipeline

extract: $(RAW_CORPUS)  ## Step 1: Extract corpus from DuckDB

diagnose: $(DIAG_CORPUS)  ## Step 2: Add diagnostic columns

report: $(REPORT_HTML)  ## Render descriptive analysis

papers: $(PAPER1_PDF) $(PAPER2_HTML) $(PAPER3_HTML)  ## Render all papers

paper1: $(PAPER1_PDF)  ## Paper 1: final working paper (Windows and Word)
paper2: $(PAPER2_HTML)  ## Paper 2: Occupation Exposure Mismatch
paper3: $(PAPER3_HTML)  ## Paper 3: Cross-Platform Cascades

# --- Step 1 ------------------------------------------------------------------
$(RAW_CORPUS): R/01_extract_corpus.R R/00_helpers.R config.yml
	$(RSCRIPT) R/01_extract_corpus.R

# --- Step 2 ------------------------------------------------------------------
$(DIAG_CORPUS): R/02_add_diagnostics.R R/00_helpers.R config.yml $(RAW_CORPUS)
	$(RSCRIPT) R/02_add_diagnostics.R

# --- Descriptive analysis ----------------------------------------------------
$(REPORT_HTML): R/03_analysis.qmd R/00_helpers.R config.yml $(RAW_CORPUS)
	$(QUARTO) R/03_analysis.qmd --output-dir ../output/reports

# --- Paper 1 -----------------------------------------------------------------
$(PAPER1_PDF): R/04_working_paper_analysis.R R/04_working_paper_template.md R/04_working_paper_references.bib R/04_build_working_paper.py R/04_export_working_paper.ps1 R/00_helpers.R config.yml $(RAW_CORPUS_EXT)
	$(RSCRIPT) R/04_working_paper_analysis.R
	python R/04_build_working_paper.py
	powershell -NoProfile -ExecutionPolicy Bypass -File R/04_export_working_paper.ps1

# --- Paper 2 -----------------------------------------------------------------
$(PAPER2_HTML): R/05_paper2_occupation_exposure_mismatch.qmd R/00_helpers.R config.yml $(RAW_CORPUS)
	$(QUARTO) R/05_paper2_occupation_exposure_mismatch.qmd --output-dir ../output/reports

# --- Paper 3 -----------------------------------------------------------------
$(PAPER3_HTML): R/06_paper3_cross_platform_cascades.qmd R/00_helpers.R config.yml $(RAW_CORPUS)
	$(QUARTO) R/06_paper3_cross_platform_cascades.qmd --output-dir ../output/reports

# ==============================================================================
# Utility targets
# ==============================================================================

clean:  ## Remove generated outputs (keeps raw data)
	rm -f $(DIAG_CORPUS)
	rm -f $(REPORT_HTML) $(PAPER2_HTML) $(PAPER3_HTML)
	rm -rf R/*_files/
	rm -rf R/.quarto/
	rm -f output/figures/*.png output/figures/*.pdf
	rm -f output/tables/*.csv output/tables/*.tex

clean-all: clean  ## Remove everything including extracted data
	rm -f $(RAW_CORPUS)

help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
