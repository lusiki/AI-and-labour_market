# ==============================================================================
# SHARED HELPERS AND CONFIGURATION LOADER
# ==============================================================================
# Source this file at the top of every script to load config and common
# functions.  Usage:  source("R/00_helpers.R")
# ==============================================================================

# --- Load configuration ------------------------------------------------------

if (!requireNamespace("yaml", quietly = TRUE)) install.packages("yaml", quiet = TRUE)
library(yaml)

CONFIG <- yaml::read_yaml("config.yml")

# convenience accessors
path_raw_corpus        <- CONFIG$paths$raw_corpus
path_diagnostic_corpus <- CONFIG$paths$diagnostic_corpus
path_analysed_corpus   <- CONFIG$paths$analysed_corpus
path_figures           <- CONFIG$paths$figures
path_tables            <- CONFIG$paths$tables
path_reports           <- CONFIG$paths$reports
path_database          <- CONFIG$paths$database
db_table               <- CONFIG$paths$db_table

# --- Ensure output directories exist -----------------------------------------

invisible(lapply(
  c("data/raw", "data/processed", path_figures, path_tables, path_reports),
  function(d) if (!dir.exists(d)) dir.create(d, recursive = TRUE)
))

# --- Common packages ---------------------------------------------------------

load_packages <- function(pkgs) {
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg, quiet = TRUE)
    }
    library(pkg, character.only = TRUE, quietly = TRUE)
  }
}

# --- Regex helpers -----------------------------------------------------------

#' Build a combined regex from a named list (label = pattern)
build_combined_regex <- function(pattern_list) {
  paste0("(", paste(unlist(pattern_list), collapse = "|"), ")")
}

#' Build SQL OR clause from a vector of LIKE patterns
build_sql_or <- function(terms, col_expr) {
  conditions <- paste0("LOWER(", col_expr, ") LIKE '%", tolower(terms), "%'")
  paste0("(", paste(conditions, collapse = " OR "), ")")
}

# --- Keyword match helpers ---------------------------------------------------

#' For a single text, find which keywords match, count them, extract context
find_matches_and_context <- function(text, keyword_list,
                                     context_chars = CONFIG$analysis$context_chars %||% 80) {
  matched  <- character(0)
  contexts <- character(0)

  for (label in names(keyword_list)) {
    pattern <- keyword_list[[label]]
    if (stringi::stri_detect_regex(text, pattern, case_insensitive = TRUE)) {
      matched <- c(matched, label)
      match_pos <- stringi::stri_locate_first_regex(text, pattern,
                                                     case_insensitive = TRUE)
      if (!is.na(match_pos[1, "start"])) {
        start <- max(1, match_pos[1, "start"] - context_chars)
        end   <- min(nchar(text), match_pos[1, "end"] + context_chars)
        ctx   <- substr(text, start, end)
        contexts <- c(contexts, paste0("[", label, "]: ...", ctx, "..."))
      }
    }
  }

  list(
    matched_terms = if (length(matched) > 0) paste(matched, collapse = "; ") else "",
    hit_count     = length(matched),
    context       = if (length(contexts) > 0) {
      paste(contexts[seq_len(min(2, length(contexts)))], collapse = " | ")
    } else ""
  )
}

# --- Logging helper ----------------------------------------------------------

log_step <- function(step, total, msg) {
  cat(sprintf("[%d/%d] %s\n", step, total, msg))
}

cat("Configuration loaded. Project root:", normalizePath("."), "\n")
