# ==============================================================================
# 01 — EXTRACT AI + LABOUR MARKET CORPUS FROM DUCKDB
# ==============================================================================
# Reads the Determ media database, applies a two-stage filter (SQL + regex),
# and writes the raw corpus to data/raw/.
#
# Usage:  Rscript R/01_extract_corpus.R          (from project root)
# ==============================================================================

source("R/00_helpers.R")

TOTAL_STEPS <- 6

# --- Packages ----------------------------------------------------------------
log_step(1, TOTAL_STEPS, "Loading packages...")
load_packages(c("DBI", "duckdb", "dplyr", "stringi", "lubridate"))

# --- Connect -----------------------------------------------------------------
log_step(2, TOTAL_STEPS, "Connecting to database...")

drv <- duckdb::duckdb(dbdir = path_database, read_only = TRUE)
con <- DBI::dbConnect(drv)
DBI::dbExecute(con, "SET memory_limit = '20GB'")   # merged DB is ~97 GB; cap RAM use

tables     <- DBI::dbListTables(con)
main_table <- db_table %||% tables[1]

row_count <- DBI::dbGetQuery(
  con, paste0('SELECT COUNT(*) AS n FROM "', main_table, '"'))$n
cat("      Table:", main_table, "\n")
cat("      Records:", format(row_count, big.mark = ","), "\n\n")

# --- SQL filtering (fast, in-database) ---------------------------------------
log_step(3, TOTAL_STEPS, "Filtering in SQL (fast, in-database)...")

ai_sql     <- CONFIG$extraction$ai_sql_terms
labour_sql <- CONFIG$extraction$labour_sql_terms

text_expr    <- "COALESCE(TITLE, '') || ' ' || COALESCE(FULL_TEXT, '')"
ai_where     <- build_sql_or(ai_sql, text_expr)
labour_where <- build_sql_or(labour_sql, text_expr)

ex          <- CONFIG$extraction
excluded    <- paste0("'", ex$exclude_source_types, "'", collapse = ", ")

query <- paste0('
SELECT
  DATE,
  replace(TITLE, chr(0), \'\')     AS TITLE,       -- API text can contain NUL bytes,
  replace(FULL_TEXT, chr(0), \'\') AS FULL_TEXT,   -- which R strings cannot hold
  replace("FROM", chr(0), \'\')    AS "FROM",
  SOURCE_TYPE, AUTO_SENTIMENT, REACH, INTERACTIONS,
  replace(URL, chr(0), \'\')       AS URL,
  LANGUAGES
FROM "', main_table, '"
WHERE "DATE" >= \'', ex$start_date, '\' AND "DATE" <= \'', ex$end_date, '\'
  AND SOURCE_TYPE NOT IN (', excluded, ')
  AND ', ai_where, '
  AND ', labour_where)

cat("      Executing query...\n")
fetch_start <- Sys.time()
corpus_raw  <- DBI::dbGetQuery(con, query)
fetch_time  <- round(difftime(Sys.time(), fetch_start, units = "secs"), 1)
cat("      Query time:", fetch_time, "seconds\n")
cat("      Articles found:", format(nrow(corpus_raw), big.mark = ","), "\n\n")

DBI::dbDisconnect(con)
duckdb::duckdb_shutdown(drv)

# --- Regex refinement --------------------------------------------------------
log_step(4, TOTAL_STEPS, "Refining with regex patterns...")

corpus_raw$text_lower <- stringi::stri_trans_tolower(
  paste(
    ifelse(is.na(corpus_raw$TITLE), "", corpus_raw$TITLE),
    ifelse(is.na(corpus_raw$FULL_TEXT), "", corpus_raw$FULL_TEXT),
    sep = " "
  )
)

ai_regex     <- build_combined_regex(CONFIG$regex$ai_patterns)
labour_regex <- build_combined_regex(CONFIG$regex$labour_patterns)

has_ai     <- stringi::stri_detect_regex(corpus_raw$text_lower, ai_regex)
has_labour <- stringi::stri_detect_regex(corpus_raw$text_lower, labour_regex)

corpus_data <- corpus_raw[has_ai & has_labour, ]
cat("      After regex refinement:", format(nrow(corpus_data), big.mark = ","), "\n\n")

# --- Process -----------------------------------------------------------------
log_step(5, TOTAL_STEPS, "Processing corpus...")

corpus_data <- corpus_data |>
  dplyr::mutate(
    DATE       = as.Date(DATE),
    year       = lubridate::year(DATE),
    month      = lubridate::month(DATE),
    year_month = lubridate::floor_date(DATE, "month")
  ) |>
  dplyr::filter(!is.na(DATE)) |>
  dplyr::distinct(TITLE, DATE, FROM, .keep_all = TRUE) |>
  dplyr::arrange(DATE)

names(corpus_data)[names(corpus_data) == "text_lower"] <- ".text_lower"

cat("      Final corpus:", format(nrow(corpus_data), big.mark = ","), "\n")
cat("      Date range:", as.character(min(corpus_data$DATE)), "to",
    as.character(max(corpus_data$DATE)), "\n\n")

# --- Save --------------------------------------------------------------------
log_step(6, TOTAL_STEPS, "Saving...")

saveRDS(corpus_data, path_raw_corpus_extended)
cat("      Saved to:", path_raw_corpus_extended, "\n")
cat("      Size:", round(file.size(path_raw_corpus_extended) / 1e6, 1), "MB\n\n")
cat("DONE! Corpus has", format(nrow(corpus_data), big.mark = ","), "articles.\n")
