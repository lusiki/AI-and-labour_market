# Working-paper edition — 29 September 2026

The requested deliverables are `ChatGPT_Croatia_Working_Paper.pdf`, `.html`, and `.docx` in this directory. They contain the same revised manuscript. The PDF is exported from the editable Word document. HTML embeds its charts and stylesheet and uses native MathML; Word equations use native Office Math.

The original `R/04_paper1_chatgpt_natural_experiment.qmd` and its report are preserved. This edition is a separate substantive revision, with the descriptive title **After ChatGPT: Media Coverage of AI’s Labour-Market Implications in Croatia**. It is an independent working paper, not an NBER publication or an arXiv submission.

## Rebuild

Run from the repository root:

```powershell
& 'C:/Program Files/R/R-4.6.0/bin/Rscript.exe' R/04_working_paper_analysis.R
python R/04_build_working_paper.py
powershell -NoProfile -ExecutionPolicy Bypass -File R/04_export_working_paper.ps1
python R/04_check_working_paper.py
node R/04_check_working_paper_html.mjs
```

The R script reads the existing corpus without modifying it. The compact scoring cache is accepted only when the corpus and configuration fingerprints match. Tables and empirical numbers in the prose are generated from the exported CSV results. The text source is `R/04_working_paper_template.md`; supplementary bibliography entries are in `R/04_working_paper_references.bib`. The build copies the original bibliography and locally corrects the compound names Lopez Bernal and de Vreese, without modifying the original file.

The Word export requires a normal Windows user session with installed Microsoft Word. The restricted tool session could not initialise Word COM; exporting from the normal user session succeeded. The packaged DOCX renderer was attempted but could not start because its `pdf2image` dependency was unavailable; LibreOffice is not installed. Actual Microsoft Word PDF export was used for pagination and visual inspection, with PyMuPDF rasterising every page. Export options are explicit and paths are normalised to native Windows form.

## Checks completed

- Corpus totals, platform totals, named-outlet totals and month counts agree.
- Monthly counts, threat shares and skills shares agree with the earlier independent review outputs.
- Skills item counts agree with monthly share × monthly corpus count.
- Fixed-outlet joint categories sum to one hundred and reproduce their marginal shares.
- Duplicate percentages agree with matched counts and eligible-title denominators.
- Stated headline directions are checked against the generated estimates.
- All citations resolve; no placeholder or unresolved-reference markers remain.
- Fourteen tables, three charts, thirty cited references and native Word/HTML equations are present.
- All twenty-three final PDF pages were visually inspected; the PDF is the actual rendering of the delivered DOCX.
- Desktop and narrow-screen HTML were checked for image loading and horizontal overflow.

Machine-readable results are in `qa/validation.json` and `qa/html-validation.json`. Input hashes and software versions are in `analysis/sha256_manifest.json` and `analysis/session_info.txt`. Intermediate PNGs, browser profiles and compact corpus caches are build/QA material, not paper deliverables.

## Co-author comments in the working-paper edition

| Comment | Response in this edition |
|---|---|
| 24sata / Styria ownership | Corrected in Section 3.2; ownership context is explicitly dated. |
| Unfindable AEM source | Removed; Reuters Institute country report is cited. |
| Unsupported neighbouring-country comparison | No assumption of equivalent exposure or concentration remains. |
| Market coverage and Dnevnik membership | Named outlets and corpus shares are explicit; national audience coverage is not claimed. |
| Portal versus social-platform shares | Table 1 reports every represented platform and entry date. |
| Portal/Facebook duplication | Matching rule, matched count and its limitations are explicit. |
| Public forums | Forum.hr, Bug.hr and Osijek031 are identified; Reddit is separate. |
| Instagram missing from chart | Included in Table 1 and Figure C1; no pre-period comparison is claimed. |
| Unexpected old persistence table | Table C5 reports recomputed post-period slopes and explains their different estimand. |
| Descriptive and result aggregates by type | Table 6 gives counts and indicator shares by type; outlet comparisons include outlet effects. |
| Conceptual-framework sources | Section 2 is written out with substantive citations. |
| Literature basis for frames | Sections 2 and 3.4 distinguish theoretical frames from unvalidated lexical measures. |
| Source-name classification | Authors’ domain mapping is explained; it is not described as an official rating. |
| AI Act outside original data | The extended sample covers both parliamentary adoption and entry into force. |
| Negative level-shift interpretation | Centred interaction, correct interpretation and recomputed estimates are shown. |
| Endogenous breakpoints | Updated dates, intervals, BIC selection and end-of-segment date convention are explained. |
| Negative tabloid coefficient versus positive prose | Signs and interpretation agree; inference is qualified for few clusters. |
| Pre-launch mentions versus Google Trends | No unsupported Google Trends claim remains; suspect timestamps are documented. |
| AI Act in figures | Retained as contextual annotations in Figure 1, with no separate causal claim. |
| Long captions | Short titles, with explanatory notes beneath tables and charts. |
| Labour-market title | The title uses “labour-market implications”; the causal “exogenous shock” assertion is removed. |

## Scientific work still required

Human coding has not been fabricated or replaced by automated scoring. Appendix B gives the validation protocol. Full date-error prevalence, interaction-metric availability and readership representativeness remain unresolved. The text explicitly limits causal and semantic claims. Presentation and numerical consistency checks do not certify those substantive assumptions or guarantee journal acceptance.
