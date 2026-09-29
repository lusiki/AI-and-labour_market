# ==============================================================================
# SHARED HELPERS AND CONFIGURATION LOADER
# ==============================================================================
# Source this file at the top of every script to load config and common
# functions.  Usage:  source("R/00_helpers.R")  OR  source("00_helpers.R")
# ==============================================================================

# --- Detect project root (works from project root OR from R/ subdirectory) ----

if (file.exists("config.yml")) {
  PROJECT_ROOT <- "."
} else if (file.exists("../config.yml")) {
  PROJECT_ROOT <- ".."
} else {
  stop("Cannot find config.yml. Run scripts from the project root or the R/ directory.")
}

# --- Load configuration ------------------------------------------------------

if (!requireNamespace("yaml", quietly = TRUE)) install.packages("yaml", quiet = TRUE)
library(yaml)

CONFIG <- yaml::read_yaml(file.path(PROJECT_ROOT, "config.yml"))

# convenience accessors (all relative to PROJECT_ROOT)
path_raw_corpus        <- file.path(PROJECT_ROOT, CONFIG$paths$raw_corpus)
path_raw_corpus_extended <- file.path(PROJECT_ROOT, CONFIG$paths$raw_corpus_extended)
path_diagnostic_corpus <- file.path(PROJECT_ROOT, CONFIG$paths$diagnostic_corpus)
path_analysed_corpus   <- file.path(PROJECT_ROOT, CONFIG$paths$analysed_corpus)
path_figures           <- file.path(PROJECT_ROOT, CONFIG$paths$figures)
path_tables            <- file.path(PROJECT_ROOT, CONFIG$paths$tables)
path_reports           <- file.path(PROJECT_ROOT, CONFIG$paths$reports)
path_database          <- CONFIG$paths$database   # absolute path, no prefix needed
db_table               <- CONFIG$paths$db_table

# --- Ensure output directories exist -----------------------------------------

invisible(lapply(
  c(file.path(PROJECT_ROOT, "data/raw"),
    file.path(PROJECT_ROOT, "data/processed"),
    path_figures, path_tables, path_reports),
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

# --- Outlet classification (paper 1) -------------------------------------------

#' Web host of an item, lower-case, without "www."
web_host <- function(from) {
  h <- stringi::stri_trans_tolower(from)
  stringi::stri_replace_first_regex(h, "^www\\.", "")
}

#' Map web items to outlets listed in CONFIG$paper1_outlets.
#' A host matches an outlet if it equals one of its domains or is a subdomain of
#' one (e.g. sportske.jutarnji.hr -> jutarnji.hr). Non-web items get NA.
#' Returns a data frame with columns outlet, outlet_type, owner.
classify_outlets <- function(from, source_type,
                             outlets = CONFIG$paper1_outlets$outlets,
                             exclude = CONFIG$paper1_outlets$exclude_hosts) {
  host <- web_host(from)
  out  <- data.frame(outlet = NA_character_, outlet_type = NA_character_,
                     owner = NA_character_, stringsAsFactors = FALSE)[rep(1, length(host)), ]
  is_web <- !is.na(source_type) & source_type == "web" & !(host %in% exclude)
  for (o in outlets) {
    pat <- paste0("(^|\\.)(", paste(gsub(".", "\\.", o$domains, fixed = TRUE),
                                    collapse = "|"), ")$")
    hit <- is_web & is.na(out$outlet) & stringi::stri_detect_regex(host, pat)
    out$outlet[hit]      <- o$name
    out$outlet_type[hit] <- o$type
    out$owner[hit]       <- o$owner
  }
  rownames(out) <- NULL
  out
}

# --- Wild-cluster bootstrap ----------------------------------------------------

#' Restricted wild-cluster bootstrap p-value (WCR, Rademacher or Webb weights)
#' for one coefficient of a linear model y ~ X, clustered on `cluster`.
#' Fixed effects should be partialled out of y and X beforehand (or included in X).
#' Follows Cameron, Gelbach & Miller (2008); Webb weights for few clusters.
wild_cluster_p <- function(y, X, cluster, param, B = 9999,
                           weights = c("webb", "rademacher"), seed = 42) {
  weights <- match.arg(weights)
  set.seed(seed)
  X  <- as.matrix(X)
  j  <- match(param, colnames(X))
  cl <- as.integer(factor(cluster))
  G  <- max(cl)

  # t-stat with CR1 cluster-robust variance
  t_stat <- function(yv) {
    XtX_inv <- solve(crossprod(X))
    b  <- XtX_inv %*% crossprod(X, yv)
    u  <- as.vector(yv - X %*% b)
    S  <- rowsum(X * u, cl)                       # G x k score sums
    V  <- XtX_inv %*% crossprod(S) %*% XtX_inv
    n  <- nrow(X); k <- ncol(X)
    V  <- V * (G / (G - 1)) * ((n - 1) / (n - k))
    b[j] / sqrt(V[j, j])
  }
  t0 <- t_stat(y)

  # Restricted model (impose coefficient = 0)
  Xr  <- X[, -j, drop = FALSE]
  br  <- solve(crossprod(Xr), crossprod(Xr, y))
  yhr <- as.vector(Xr %*% br)
  ur  <- as.vector(y - yhr)

  draw <- function() {
    if (weights == "rademacher") sample(c(-1, 1), G, replace = TRUE)
    else sample(c(-sqrt(1.5), -1, -sqrt(0.5), sqrt(0.5), 1, sqrt(1.5)), G, replace = TRUE)
  }
  t_b <- vapply(seq_len(B), function(b) t_stat(yhr + ur * draw()[cl]), numeric(1))
  list(t = as.numeric(t0), p = mean(abs(t_b) >= abs(as.numeric(t0))), G = G, B = B)
}

# --- Logging helper ----------------------------------------------------------

log_step <- function(step, total, msg) {
  cat(sprintf("[%d/%d] %s\n", step, total, msg))
}

cat("Configuration loaded. Project root:", normalizePath(PROJECT_ROOT), "\n")
