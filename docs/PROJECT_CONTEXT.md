# Croatian Digital Media Analysis Project

## Overview

This project analyzes Croatian digital media content from the Determ platform (formerly Mediatoolkit). The database contains approximately 20 million records spanning January 2021 to May 2024, covering web portals, Facebook, Twitter/X, Instagram, YouTube, TikTok, Reddit, and Forum.hr.

The infrastructure supports multiple research questions through keyword-based corpus extraction, frame analysis, actor identification, sentiment analysis, and temporal dynamics.

---

## Data Infrastructure

### Database

| Property | Value |
|----------|-------|
| Format | DuckDB |
| Path | `C:/Users/lsikic/Luka C/DetermDB/determDB.duckdb` |
| Table | `media_data` |
| Records | ~20 million |
| Period | January 2021 to May 2024 |

### Schema

Core columns available for analysis:

| Column | Description |
|--------|-------------|
| DATE | Publication date |
| TITLE | Article/post title |
| FULL_TEXT | Complete text content |
| FROM | Source name (outlet, account) |
| SOURCE_TYPE | Platform type (web, Facebook, Twitter, etc.) |
| AUTO_SENTIMENT | Determ automated sentiment (positive, neutral, negative) |
| REACH | Estimated audience reach |
| INTERACTIONS | Engagement count |
| URL | Original content URL |
| LANGUAGES | Detected language |
| MENTION_SNIPPET | Short text excerpt (~200 chars) |

### Platform Distribution

The database covers multiple platform types. SOURCE_TYPE values include web (news portals), Facebook, Twitter, Instagram, YouTube, TikTok, Reddit, and forum content. Web portals typically contain longer editorial content while social media contains shorter user-generated content.

---

## Corpus Extraction Framework

### General Approach

Research corpora are created using intersection logic:

```
Corpus = Group_A ∩ Group_B
```

An article enters the corpus only if it contains at least one term from Group A AND at least one term from Group B. This reduces false positives compared to single-keyword searches.

### Implementation

**Step 1: SQL filtering (fast, in database)**
- Use LIKE patterns to identify candidate articles
- Fetches only potential matches, not entire database

**Step 2: Regex refinement (precise, in R)**
- Apply regex patterns with morphological variations
- Croatian language requires stem-based patterns for declensions

**Step 3: Diagnostic enrichment**
- Add columns showing which keywords matched
- Extract context snippets around matches
- Count distinct keyword hits per article

### Diagnostic Columns

Every corpus should include these columns for quality control:

| Column | Purpose |
|--------|---------|
| which_groupA_terms | List of Group A keywords found |
| which_groupB_terms | List of Group B keywords found |
| groupA_hit_count | Number of distinct Group A matches |
| groupB_hit_count | Number of distinct Group B matches |
| groupA_context | Text snippet around Group A match |
| groupB_context | Text snippet around Group B match |

These enable filtering by match strength and manual verification of relevance.

---

## Croatian Language Considerations

Croatian is a highly inflected language. Keywords must account for:

**Noun declensions (7 cases):**
- posao, posla, poslu, poslom, poslovi, poslova, poslovima

**Verb conjugations:**
- zaposliti, zapošljavam, zapošljavaju, zaposlen, zaposlena

**Adjective agreement:**
- umjetna inteligencija, umjetne inteligencije, umjetnom inteligencijom

**Solution:** Use regex patterns with character classes and wildcards:
- `zaposlen` catches zaposleni, zaposlenika, zaposlenik, etc.
- `umjetn.*inteligencij` catches all case combinations
- `radn.*mjest` catches radno mjesto, radna mjesta, radnih mjesta, etc.

---

## Media Outlet Classification

Croatian media outlets can be categorized for comparative analysis:

| Category | Outlets | Characteristics |
|----------|---------|-----------------|
| Tabloid | 24sata, Index, Net.hr | High volume, sensational framing |
| Quality | Jutarnji, Večernji, N1, Telegram, Tportal | Longer articles, balanced framing |
| Regional | Slobodna Dalmacija, Novi List, Glas Slavonije | Local perspective |
| Public | HRT | Public broadcaster, regulatory obligations |
| Tech | Bug, Netokracija, Zimo, Rep.hr | Technology focus, expert audience |
| Business | Poslovni, Lider, Forbes HR | Economic framing, business audience |

Classification is done via regex matching on the FROM column.

---

## Analysis Components

### Frame Analysis

Frames are identified through keyword dictionaries. Each frame represents an interpretive lens through which a topic is presented.

**Implementation:**
- Define keyword list for each frame
- Detect presence/absence per article
- Calculate frame frequency and co-occurrence
- Track frame evolution over time
- Compare frames across outlet types

### Actor Analysis

Actors are entities whose perspectives appear in coverage.

**Implementation:**
- Define keyword list for each actor type
- Detect mentions per article
- Analyze actor-frame associations
- Track actor prominence over time

### Sentiment Analysis

**Sources:**
- AUTO_SENTIMENT from Determ (pre-computed)
- Custom sentiment lexicons (Croatian positive/negative words)

**Applications:**
- Overall sentiment distribution
- Sentiment by frame
- Sentiment trends over time
- Sentiment by outlet type

### Temporal Analysis

**Key elements:**
- Monthly/quarterly volume trends
- Event-based analysis (anchor to external events)
- Phase definitions (pre/post major events)
- Changepoint detection for trend shifts

---

## Current Research Application: AI and Labour Market

### Research Questions

1. **Volume and dynamics:** How much coverage does AI + labour market receive? How did it change over time?

2. **Frames:** Which interpretive frames dominate? How did frame prevalence change?

3. **Actors:** Whose perspectives appear most often?

4. **Sources:** Do different media types frame the topic differently?

### Keyword Groups

**Group A: AI and Technology**

| Label | Regex Pattern |
|-------|---------------|
| umjetna inteligencija | `umjetn.*inteligencij` |
| strojno učenje | `strojn.*učenj` |
| ChatGPT | `chat.?gpt` |
| GPT-4/GPT-3 | `gpt.?[34]` |
| OpenAI | `openai\|open ai` |
| generativni AI | `generativn.*(ai\|umjetn)` |
| automatizacija | `automatizacij` |
| robotizacija | `robotizacij` |
| algoritam | `algoritm` |
| neuronska mreža | `neuronsk\|neuralna` |
| chatbot | `chatbot` |
| LLM | `\\bllm\\b` |
| Gemini | `\\bgemini\\b` |
| Copilot | `copilot` |
| duboko učenje | `duboko.*učenj` |

**Group B: Labour Market**

| Label | Regex Pattern |
|-------|---------------|
| posao/poslovi | `\\bposao\|\\bposlovi\|\\bposlove\|\\bposlova` |
| zaposleni | `zaposlen\|zapošljav` |
| nezaposlenost | `nezaposlen` |
| radno mjesto | `radn.*mjest` |
| tržište rada | `tržišt.*rada` |
| vještine | `vještin` |
| kompetencije | `kompetencij` |
| karijera | `karijer` |
| produktivnost | `produktivnost` |
| otpuštanje | `otpuštan` |
| prekvalifikacija | `prekvalifikacij\|dokvalifikacij` |
| plaća | `\\bplaća\|\\bplaće\|\\bplaću` |
| poslodavac | `poslodav` |
| radna snaga | `radn.*snag` |
| zanimanje | `zaniman` |

### Frame Dictionaries

| Frame | Description | Example Keywords |
|-------|-------------|------------------|
| JOB_LOSS | AI eliminates jobs | gubitak posla, zamjena radnika, otpuštanje, krade poslove |
| JOB_CREATION | AI creates opportunities | nova radna mjesta, nove prilike, potražnja za stručnjacima |
| TRANSFORMATION | AI changes rather than destroys work | transformacija rada, prilagodba, nadopunjuje, suradnja |
| SKILLS | Focus on reskilling | prekvalifikacija, digitalne vještine, cjeloživotno učenje |
| REGULATION | Policy and governance | regulacija AI, AI Act, zaštita radnika, sindikat |
| PRODUCTIVITY | Economic benefits | produktivnost, učinkovitost, konkurentnost |
| INEQUALITY | Distributional concerns | digitalni jaz, nejednakost, polarizacija |
| FEAR_RESISTANCE | Anxiety and opposition | strah od AI, prijetnja, nesigurnost |

### Actor Dictionaries

| Actor | Keywords |
|-------|----------|
| WORKERS | radnik, zaposlenik, djelatnik |
| EMPLOYERS | poslodavac, tvrtka, poduzeće, korporacija |
| TECH_COMPANIES | OpenAI, Google, Microsoft, Meta, Nvidia |
| POLICY_MAKERS | vlada, ministarstvo, sabor, EU komisija |
| EXPERTS | stručnjak, znanstvenik, profesor, analitičar |
| UNIONS | sindikat, radnička prava |

### Key Events Timeline

| Date | Event | Expected Impact |
|------|-------|-----------------|
| 2022-11-30 | ChatGPT launch | Volume spike, fear framing increase |
| 2023-03-14 | GPT-4 release | Continued attention, capability focus |
| 2023-07-01 | EU AI Act draft | Regulation frame increase |
| 2024-03-13 | EU AI Act adopted | Policy discussion peak |

### Output Files

| File | Path |
|------|------|
| Raw corpus | `C:/Users/lsikic/Desktop/ai_labour_corpus.rds` |
| Diagnostic corpus | `C:/Users/lsikic/Desktop/ai_labour_corpus_diagnostic.rds` |

---

## Potential Future Research Applications

This infrastructure supports many other research questions:

### Elections and Political Coverage
- Group A: election terms (izbori, glasovanje, kandidat, stranka)
- Group B: specific parties, politicians, or issues
- Frames: horse race, policy, scandal, personality

### Health and Pandemic
- Group A: health terms (zdravlje, bolnica, liječnik, COVID)
- Group B: policy terms or specific conditions
- Frames: risk, reassurance, blame, scientific

### Climate and Environment
- Group A: climate terms (klima, okoliš, emisije, zeleno)
- Group B: economy, policy, or specific sectors
- Frames: crisis, opportunity, denial, action

### EU and Foreign Policy
- Group A: EU terms (europska unija, brisel, integracije)
- Group B: specific policy areas or countries
- Frames: sovereignty, cooperation, bureaucracy

### Migration
- Group A: migration terms (migranti, izbjeglice, azil)
- Group B: security, economy, or humanitarianism
- Frames: threat, victim, burden, benefit

### Technology Adoption (General)
- Group A: any technology (blockchain, IoT, 5G, electric vehicles)
- Group B: context terms (business, society, regulation)
- Frames: innovation, disruption, risk, opportunity

---

## Technical Notes

### DuckDB Connection Issues

DuckDB has a path normalization bug when called from Quarto/knitr. The solution is to separate extraction (plain R script) from analysis (Quarto document).

**Workflow:**
1. Run extraction script in RStudio (creates RDS file)
2. Render Quarto document (loads RDS file)

### Memory Management

Full database is ~36GB when loaded into R. Always filter in SQL before fetching:

```r
# Bad: loads everything
dta <- dbGetQuery(con, "SELECT * FROM media_data")

# Good: filters first
dta <- dbGetQuery(con, "SELECT * FROM media_data WHERE [conditions]")
```

### Performance Tips

- Use SQL LIKE for initial filtering (fast)
- Use R regex for refinement (precise)
- Process in chunks for progress feedback
- Close DuckDB connections properly with `duckdb_shutdown(drv)`

---

## File Structure

```
Project/
├── DetermDB/
│   └── determDB.duckdb          # Main database
├── Scripts/
│   ├── 01_extract_corpus.R      # Corpus extraction
│   ├── 02_add_diagnostics.R     # Add diagnostic columns
│   └── 03_analysis.qmd          # Quarto analysis
├── Data/
│   ├── corpus.rds               # Extracted corpus
│   └── corpus_diagnostic.rds    # With diagnostic columns
└── PROJECT_CONTEXT.md           # This file
```

---

## Quality Control Checklist

Before analysis, verify:

- [ ] Corpus size is reasonable (not too small, not suspiciously large)
- [ ] Date range matches expectations
- [ ] Sample titles are relevant to research question
- [ ] Keyword hit distributions make sense
- [ ] Low-hit articles reviewed for false positives
- [ ] SOURCE_TYPE distribution appropriate for research question
- [ ] Duplicates/syndication handled appropriately

---

## Contact and Attribution

Database source: Determ platform (Croatian media monitoring)

Research context: Media framing analysis, Faculty of Humanities and Social Sciences

---

*This document provides context for AI assistants working on this project. Update as the project evolves.*
