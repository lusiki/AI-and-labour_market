# ==============================================================================
# 02 — ADD DIAGNOSTIC COLUMNS TO CORPUS
# ==============================================================================
# Enriches each article with columns showing which AI and labour keywords
# matched, how many matched, and a context snippet around the first hit.
#
# Usage:  Rscript R/02_add_diagnostics.R          (from project root)
# ==============================================================================

source("R/00_helpers.R")

# --- Packages ----------------------------------------------------------------
load_packages(c("dplyr", "stringi"))

# --- Load corpus -------------------------------------------------------------
cat("Loading corpus from:", path_raw_corpus, "\n")
corpus_data <- readRDS(path_raw_corpus)
cat("Articles loaded:", format(nrow(corpus_data), big.mark = ","), "\n\n")

# --- Keyword dictionaries (from config) --------------------------------------
ai_keywords     <- CONFIG$regex$ai_patterns
labour_keywords <- CONFIG$regex$labour_patterns

# --- Create text column if missing -------------------------------------------
if (!".text_lower" %in% names(corpus_data)) {
  cat("Creating text column...\n")
  corpus_data$.text_lower <- stringi::stri_trans_tolower(
    paste(
      ifelse(is.na(corpus_data$TITLE), "", corpus_data$TITLE),
      ifelse(is.na(corpus_data$FULL_TEXT), "", corpus_data$FULL_TEXT),
      sep = " "
    )
  )
}

# --- Process articles --------------------------------------------------------
cat("Adding diagnostic columns...\n")
cat("Processing", nrow(corpus_data), "articles.\n\n")

corpus_data$which_ai_terms     <- ""
corpus_data$ai_hit_count       <- 0L
corpus_data$ai_context         <- ""
corpus_data$which_labour_terms <- ""
corpus_data$labour_hit_count   <- 0L
corpus_data$labour_context     <- ""

n <- nrow(corpus_data)
progress_points <- round(seq(0.1, 1, by = 0.1) * n)

for (i in seq_len(n)) {
  if (i %in% progress_points) cat("  ", round(i / n * 100), "%\n")

  text <- corpus_data$.text_lower[i]

  ai_result <- find_matches_and_context(text, ai_keywords)
  corpus_data$which_ai_terms[i] <- ai_result$matched_terms
  corpus_data$ai_hit_count[i]   <- ai_result$hit_count
  corpus_data$ai_context[i]     <- ai_result$context

  labour_result <- find_matches_and_context(text, labour_keywords)
  corpus_data$which_labour_terms[i] <- labour_result$matched_terms
  corpus_data$labour_hit_count[i]   <- labour_result$hit_count
  corpus_data$labour_context[i]     <- labour_result$context
}

# --- Summary -----------------------------------------------------------------
cat("\n=== SUMMARY ===\n\n")

cat("AI hit count distribution:\n")
print(table(corpus_data$ai_hit_count))

cat("\nLabour hit count distribution:\n")
print(table(corpus_data$labour_hit_count))

cat("\nMost common AI terms:\n")
ai_all <- unlist(strsplit(corpus_data$which_ai_terms, "; "))
ai_all <- ai_all[ai_all != ""]
print(head(sort(table(ai_all), decreasing = TRUE), 10))

cat("\nMost common Labour terms:\n")
lab_all <- unlist(strsplit(corpus_data$which_labour_terms, "; "))
lab_all <- lab_all[lab_all != ""]
print(head(sort(table(lab_all), decreasing = TRUE), 10))

# --- Save --------------------------------------------------------------------
cat("\nSaving to:", path_diagnostic_corpus, "\n")
saveRDS(corpus_data, path_diagnostic_corpus)
cat("Done! Size:", round(file.size(path_diagnostic_corpus) / 1e6, 1), "MB\n")

# --- Sample ------------------------------------------------------------------
cat("\n=== SAMPLE (5 articles) ===\n\n")
set.seed(CONFIG$analysis$seed)
sample_idx <- sample(nrow(corpus_data), min(5, nrow(corpus_data)))
for (i in sample_idx) {
  cat("---\n")
  cat("Title:", substr(corpus_data$TITLE[i], 1, 70), "...\n")
  cat("AI terms:", corpus_data$which_ai_terms[i], "\n")
  cat("Labour terms:", corpus_data$which_labour_terms[i], "\n")
  cat("AI context:", substr(corpus_data$ai_context[i], 1, 120), "\n\n")
}
