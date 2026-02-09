# Data Dictionary / Codebook

## Overview

This document describes the variables in the project datasets. All data files
are stored in R serialized format (`.rds`) and can be loaded with `readRDS()`.

---

## 1. Raw corpus (`data/raw/ai_labour_corpus.rds`)

Produced by `R/01_extract_corpus.R`. Contains articles from the Determ media
database that match both AI and labour-market keyword groups.

| Variable | Type | Description |
|----------|------|-------------|
| `DATE` | Date | Publication date (YYYY-MM-DD) |
| `TITLE` | character | Article/post title |
| `FULL_TEXT` | character | Complete text content |
| `FROM` | character | Source name (outlet, social media account) |
| `SOURCE_TYPE` | character | Platform type: `web`, `Facebook`, `Twitter`, `Instagram`, `YouTube`, `TikTok`, `Reddit`, `forum` |
| `AUTO_SENTIMENT` | character | Determ automated sentiment: `positive`, `neutral`, `negative` |
| `REACH` | numeric | Estimated audience reach |
| `INTERACTIONS` | numeric | Engagement count (likes, shares, comments) |
| `URL` | character | Original content URL |
| `LANGUAGES` | character | Detected language code |
| `year` | integer | Publication year |
| `month` | integer | Publication month (1--12) |
| `year_month` | Date | First day of publication month |
| `.text_lower` | character | Lowercased concatenation of TITLE + FULL_TEXT (internal) |

**Filtering logic**: An article is included if it matches at least one AI
keyword AND at least one labour-market keyword (see `config.yml` for full
keyword lists).

**Deduplication**: Articles are deduplicated on (TITLE, DATE, FROM).

---

## 2. Diagnostic corpus (`data/processed/ai_labour_corpus_diagnostic.rds`)

Produced by `R/02_add_diagnostics.R`. Extends the raw corpus with six columns
that record which keywords matched.

All columns from the raw corpus, plus:

| Variable | Type | Description |
|----------|------|-------------|
| `which_ai_terms` | character | Semicolon-separated list of AI keywords found |
| `ai_hit_count` | integer | Number of distinct AI keyword patterns matched |
| `ai_context` | character | Text snippet (~160 chars) around the first AI match |
| `which_labour_terms` | character | Semicolon-separated list of labour keywords found |
| `labour_hit_count` | integer | Number of distinct labour keyword patterns matched |
| `labour_context` | character | Text snippet (~160 chars) around the first labour match |

---

## 3. Analysed corpus (`data/processed/ai_labour_corpus_analysed.rds`)

Produced by `R/03_analysis.qmd` (export chunk). Extends the raw corpus with
frame, actor, and outlet-type annotations.

Additional columns beyond the raw corpus:

| Variable | Type | Description |
|----------|------|-------------|
| `word_count` | integer | Number of whitespace-separated tokens in FULL_TEXT |
| `quarter` | integer | Publication quarter (1--4) |
| `year_quarter` | character | e.g. "2023 Q2" |
| `frame_JOB_LOSS` | logical | TRUE if JOB_LOSS frame keywords detected |
| `frame_JOB_CREATION` | logical | TRUE if JOB_CREATION frame keywords detected |
| `frame_TRANSFORMATION` | logical | TRUE if TRANSFORMATION frame keywords detected |
| `frame_SKILLS` | logical | TRUE if SKILLS frame keywords detected |
| `frame_REGULATION` | logical | TRUE if REGULATION frame keywords detected |
| `frame_PRODUCTIVITY` | logical | TRUE if PRODUCTIVITY frame keywords detected |
| `frame_INEQUALITY` | logical | TRUE if INEQUALITY frame keywords detected |
| `frame_FEAR_RESISTANCE` | logical | TRUE if FEAR_RESISTANCE frame keywords detected |
| `actor_WORKERS` | logical | TRUE if WORKERS actor keywords detected |
| `actor_EMPLOYERS` | logical | TRUE if EMPLOYERS actor keywords detected |
| `actor_TECH_COMPANIES` | logical | TRUE if TECH_COMPANIES actor keywords detected |
| `actor_POLICY_MAKERS` | logical | TRUE if POLICY_MAKERS actor keywords detected |
| `actor_EXPERTS` | logical | TRUE if EXPERTS actor keywords detected |
| `actor_UNIONS` | logical | TRUE if UNIONS actor keywords detected |
| `outlet_type` | character | Media classification: `Tabloid`, `Quality`, `Regional`, `Public`, `Tech`, `Business`, `Other` |

---

## 4. Frame definitions

Eight interpretive frames, defined in `config.yml`:

| Frame | Description | N keywords |
|-------|-------------|-----------|
| JOB_LOSS | AI eliminates jobs | 22 |
| JOB_CREATION | AI creates new opportunities | 13 |
| TRANSFORMATION | AI transforms rather than destroys work | 16 |
| SKILLS | Focus on reskilling and education | 14 |
| REGULATION | Policy, governance, and worker protection | 13 |
| PRODUCTIVITY | Economic benefits and efficiency | 11 |
| INEQUALITY | Distributional concerns and digital divide | 11 |
| FEAR_RESISTANCE | Anxiety, fear, and opposition to AI | 16 |

---

## 5. Actor definitions

Six actor categories, defined in `config.yml`:

| Actor | Keywords |
|-------|----------|
| WORKERS | radnik, radnici, radnica, zaposlenik, zaposlenici, djelatnik, djelatnici |
| EMPLOYERS | poslodavac, poslodavci, tvrtka, tvrtke, poduzeće, kompanija, korporacija |
| TECH_COMPANIES | openai, google, microsoft, meta, amazon, nvidia, chatgpt, deepmind |
| POLICY_MAKERS | vlada, ministar, ministarstvo, sabor, eu komisija, europska komisija |
| EXPERTS | stručnjak, ekspert, znanstvenik, istraživač, analitičar, profesor |
| UNIONS | sindikat, sindikalni |

---

## 6. Outlet type classification

Media outlets classified by regex on the `FROM` column:

| Type | Example outlets |
|------|----------------|
| Tabloid | 24sata, Index, Net.hr |
| Quality | Jutarnji, Večernji, N1, Telegram, Tportal |
| Regional | Slobodna Dalmacija, Novi List |
| Public | HRT |
| Tech | Bug, Netokracija |
| Business | Poslovni, Lider, Forbes HR |
| Other | All unclassified sources |
