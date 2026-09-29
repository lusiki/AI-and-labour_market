# 1. Introduction

The public release of ChatGPT in November 2022 made generative artificial intelligence (AI) unusually visible in discussions of work. Yet greater visibility does not establish either a sudden change in news production or a change in how journalists describe employment consequences. Coverage can expand while its composition changes gradually, and language about risks can become more common even as the absolute volume of reporting on skills increases. Distinguishing these possibilities is necessary before drawing conclusions about the information available to workers.

This paper studies media items retrieved from a commercial monitoring database for Croatia between {{START}} and {{END}}. The corpus contains {{N}} items that satisfy a two-stage AI-and-labour keyword filter. We examine coverage volume, dictionary-defined indicators of risk and opportunity, differences across outlet categories, title similarity across sources, and recorded interactions with web items. A complementary analysis holds the set of named news outlets fixed and gives outlets equal weight. This separates some changes within outlets from changes in their contribution to the aggregate corpus.

The release is a useful calendar reference, but the available design does not identify its causal effect. Every outlet experiences the same event, and there is no untreated comparison series. Moreover, a targeted date audit finds records whose stored dates conflict with their content or publisher information. We therefore interpret the estimates as descriptive changes around the release and subsequent diffusion of generative AI. The word “shock” describes a historically salient event; it is not an identification assumption.

Three findings organise the analysis. First, the pooled count series accelerates after the launch. Second, the monthly share matching the threat dictionary rises from {{TH_PRE}}% to {{TH_POST}}%, while the skills share falls from {{SK_PRE}}% to {{SK_POST}}%. These are changes in relative attention: the average monthly count of skills-matching items rises from {{SK_N_PRE}} to {{SK_N_POST}}. Third, the outlet and engagement results are less decisive than their simplest specifications suggest. The estimated tabloid differential is negative, but the comparison has few outlet clusters. The positive association between threat language and interactions depends on how zeros and the outcome scale are handled.

The contribution is a longitudinal description of AI-and-work coverage in a Croatian monitoring corpus, linked to a transparent measurement and data-quality assessment. It extends the focus of much existing AI-media research from general technological narratives to employment risks, opportunities and adaptation. Its strongest substantive question is whether growing discussion of risk is accompanied by discussion of skills. It does not estimate changes in public beliefs, national employment or the causal consequences of ChatGPT.

# 2. Literature and conceptual framework

## 2.1. Labour-market uncertainty and media framing

Task-based accounts of technological change distinguish displacement from complementarities and the creation of new tasks. Autor explains why automation of some tasks can coexist with continued demand for labour; Acemoglu and Restrepo formalise the opposing forces of automation and new tasks [@autor2015why; @acemoglu2018race]. Studies of AI exposure describe the potential reach of technical capabilities, rather than realised job losses. This distinction applies both to general AI exposure measures and to assessments of large language models [@felten2021ai; @eloundou2024gpts]. Evidence from the introduction of a generative-AI assistant in customer support further shows that effects can differ across workers and depend on the setting [@brynjolfsson2025generative]. These studies motivate separate attention to job loss, job creation, productivity, transformation and skills; they do not imply that a newspaper mentioning any of these topics accurately describes an economic effect.

Framing concerns the selection and emphasis of aspects of an issue, including the problem being defined, its causes, evaluations and possible responses [@entman1993framing]. Scheufele distinguishes media frames from audience frames and the processes linking them [@scheufele1999framing]. That distinction matters here: text is observed, audience interpretation is not. De Vreese's distinction between generic and issue-specific frames also cautions against treating any negative word as a complete frame [@devreese2005framing]. Generic categories such as conflict, responsibility and economic consequences provide a useful conceptual backdrop, but require explicit operationalisation in a particular corpus [@semetkovalkenburg2000].

We translate this literature into a narrower empirical object: lexical indicators of labour-related narratives inside a keyword-selected corpus. Job-loss and inequality expressions approximate possible problems; productivity and job-creation expressions approximate possible benefits; skills and regulation expressions approximate adaptation or collective responses. Transformation can describe either beneficial or costly adjustment and is therefore not intrinsically positive. The “opportunity” composite retains transformation for comparability with the initial specification, while disaggregated results allow readers to assess that choice. Threat and opportunity indicators are non-exclusive, and neither is a direct measure of sentiment, factual accuracy or audience persuasion.

## 2.2. AI news, negativity and outlet differences

Earlier research shows that AI coverage combines optimism with identifiable areas of concern. Fast and Horvitz document long-run changes in newspaper discussion, including growing concern about work [@fasthorvitz2017]. Chuan, Tsai and Cho find benefits discussed more often than risks in their newspaper sample, with risks often described more specifically [@chuan2019framing]. Ouchchy, Coin and Dubljević examine the ethical dimensions of AI reporting and emphasise limitations in the depth of coverage [@ouchchy2020headlines]. These findings support analysing the content of risk language alongside its frequency.

Nguyen and Hekman find that AI discourse became more critical over time and link media narratives to data risks and public understanding [@nguyenhekman2024]. Roe and Perkins show how UK headlines shortly after ChatGPT's release alternated between promise and danger [@roeperkins2023]. The Croatian case adds a longer post-release horizon and an explicit labour-market filter. It also requires attention to language-specific measurement. We make no claim that the Croatian labour market has the same occupational exposure or media concentration as neighbouring countries.

Negativity may attract attention, but several distinct mechanisms are possible. Studies of reactions to news demonstrate sensitivity to negative information [@soroka2015negativity; @soroka2019crossnational]. A large randomised headline study finds that negative wording can increase clicks in its setting [@robertson2023negativity]. That experimental result motivates an engagement question here; it does not identify the effect of negativity in observational Croatian interaction data. Article topic, prominence, audience size, distribution channels and measurement practices can influence both language and recorded engagement.

Media-economics accounts connect content to audience preferences and market incentives [@mullainathanshleifer2005; @gentzkowshapiro2010]. They permit competing expectations about outlet differences. Popular outlets may emphasise emotionally vivid risks; general-interest outlets serving professionally exposed readers may devote more attention to occupational consequences. “Tabloidisation” is itself multidimensional, involving style, topic selection and editorial priorities [@esser1999tabloidization]. Our outlet categories are research classifications, not official ratings of journalistic quality or direct measures of business models.

## 2.3. Research questions

The analysis addresses four questions. How does the amount of retrieved AI-and-labour coverage evolve around the launch? Do risk, opportunity and skills indicators change together or diverge? Are changes similar across outlet categories and within a fixed set of outlets? Finally, how do lexical indicators relate to title similarity and recorded engagement? All specifications are exploratory: the observation window and dictionaries were not preregistered, and the robustness analyses were developed during manuscript review. Statistical significance is therefore treated as one diagnostic, alongside magnitude, specification sensitivity and data validity.

# 3. Data, market scope and measurement

## 3.1. Corpus construction and observation unit

The source is one Determ database covering {{MONTHS}} consecutive calendar months, with {{PRE_MONTHS}} months before December 2022 and {{POST_MONTHS}} months from December 2022 onward. SQL first requires an AI-related expression and a labour-related expression in the concatenated title and full text. A second regular-expression filter refines the selection. Items classified as reader comments are excluded. Exact repeats of the same title, stored date and source are removed. An observation is a retrieved item, rather than a unique underlying story or an individual reader's exposure.

The retrieval vocabulary includes automation, robotisation and algorithms as well as generative AI and named products. Consequently, the study concerns the evolution of a broad AI-and-labour discussion around ChatGPT, rather than a corpus restricted to ChatGPT. The two filtering stages are not identical: some terms recognised at the regular-expression stage, including standalone wage or employer expressions, are absent from the SQL prefilter. A record must pass both stages. The resulting scope is narrower than the union of the two vocabularies, and corpus recall has not been established. The code and exact dictionaries accompany the reproducible source.

Web items account for {{WEB_SHARE}}% of the corpus. The remainder includes social posts, public forum posts and print or broadcast items. It would therefore be inaccurate to call every pooled observation a digital news article. Table 1 gives platform counts and first observed qualifying items. Instagram is included, with {{INSTAGRAM_N}} items; its first observed item occurs in {{INSTAGRAM_FIRST}}, so it cannot support a pre-launch comparison.

{{TABLE_PLATFORMS}}

The public-forum category contains named discussion boards rather than an unspecified national sample. Forum.hr accounts for {{FORUM_SHARE}}% of forum items, followed by the Bug.hr forum and boards including Osijek031. Reddit is a separate platform category. Titles and complete item texts can contain quotations, navigation text or unrelated material. Database language tags do not by themselves certify Croatian language or a Croatian audience. The named-outlet analysis provides a more geographically interpretable subset of the broader monitored corpus.

## 3.2. Named outlets and what “coverage” means

The named web-outlet subset contains {{NAMED_N}} items from {{NAMED_OUTLETS}} observed outlets, representing {{NAMED_SHARE}}% of all retrieved items and {{NAMED_WEB_SHARE}}% of web items. These are corpus shares, not shares of national readership, advertising revenue or the Croatian population. The Reuters Institute's country report documents major brands and their ownership, but its survey reach measures cannot be added across brands to estimate unduplicated coverage of our corpus [@perusko2024croatia]. No defensible national market-coverage percentage is available from the present extract.

Ownership and the sampling frame are distinct. In the ownership context reported for 2024, Styria includes 24sata and Večernji list; Hanza includes Jutarnji list and Slobodna Dalmacija; United Group includes the Nova TV/Dnevnik and N1 operations; and RTL belongs to CME [@perusko2024croatia]. Net.hr's transfer from Telegram to RTL was announced in 2021 [@nethr2021rtl]. We do not count 24sata as an owner group separate from Styria, nor treat these ownership descriptions as an exhaustive or time-invariant ownership census. Additional public, regional, specialist and business outlets broaden the sample beyond the largest general-interest brands. Dnevnik.hr is explicitly included in this expanded named-outlet set.

Classification is performed by the authors using a documented mapping of web domains. A host must match a listed domain or one of its subdomains; the separately operated emedjimurje.net.hr host is excluded from Net.hr. “Tabloid” identifies 24sata, Index.hr and Net.hr; “quality” is shorthand for the general-interest comparison category listed in Table 2. These labels do not come from an official database classification. Other named outlets are grouped as regional, public, technology or business media. The classifications are held fixed for analysis, without assuming that ownership or editorial practice is fixed over time.

{{TABLE_OUTLETS}}

## 3.3. Dates and duplicated stories

A targeted chronology check identifies {{SUSPECT_N}} stored pre-launch items containing “ChatGPT” whose publisher information or described events point to later dates. These include a Dnevnik.hr article displayed as published in March 2023, two Noć knjige event pages referring to April 2023, and an Osiguranje.hr story listed by the publisher in September 2023. Event dates and publication dates are not interchangeable. We preserve the stored dates in the baseline to make it reproducible, then exclude these records in a sensitivity analysis. This check does not estimate the prevalence of date errors elsewhere in the archive. It prevents interpreting the suspect observations as demonstrated anticipation of the launch. Appendix C provides an audit trail.

Cross-platform duplication remains possible after exact item deduplication. Normalised headline matching within a two-day window finds {{FB_MATCHED}} web-linked matches among {{FB_N}} Facebook posts ({{FB_MATCH_SHARE}}%). This restrictive rule misses shortened captions, rewritten titles and delayed reposts, so it is a lower-bound-style diagnostic rather than an estimate of all shared content. Platform-level observations are kept distinct because they describe monitored distribution, while dependence across versions of a story remains a limitation.

## 3.4. Dictionary indicators and validation status

Each indicator equals one when at least one configured expression matches the lowercased title-plus-text field. The dictionaries cover job loss, job creation, transformation, skills, regulation, productivity, inequality, and fear or resistance. The threat composite is the union of job loss, fear/resistance and inequality. The opportunity composite is the union of job creation, productivity and transformation. Multiple indicators may be present in the same item; their percentages need not sum to one hundred. Appendix A gives the conceptual mapping and the complete expressions.

These measures have not yet been validated against independent human coding. A generic word such as “danger” or “warning” need not refer to AI or employment, and a skills term can occur in a product review. Negation, quoted speech and the distinction between a journalist's claim and an attributed claim are not modelled. Dictionary matches therefore measure lexical prevalence in the retrieved text, not established semantic frames. Automated content analysis requires application-specific validation [@grimmerstewart2013].

Measurement error need not merely attenuate every result. False positives, false negatives and their variation by outlet, period, text length or platform can change both levels and trends. Under stable sensitivity and specificity, a binary prevalence difference is scaled by their sum minus one; stability is an assumption to test, not a property of this corpus. Appendix B specifies a blinded coding protocol and reporting requirements. No human-coding accuracy, intercoder agreement or corrected prevalence is reported as an observed result.

# 4. Empirical approach

## 4.1. Temporal summaries and segmented regressions

We report both item counts and monthly percentages. Unless explicitly stated otherwise, a pre- or post-period percentage is an unweighted mean of monthly percentages. An item-weighted share answers a different question when coverage volume grows; the outlet-type tables identify that alternative denominator explicitly. December 2022 is the first full month after the public release.

For monthly volume or an indicator share, the segmented specification is

$$Y_t = \alpha + \beta t + \delta P_t + \gamma (t-t_0)P_t + \varepsilon_t,$$

where $P_t$ indicates December 2022 onward and $t_0$ is the launch-month index. The coefficient $\delta$ is the fitted level difference at the boundary; $\gamma$ is the change in slope. Centring the interaction at $t_0$ is essential for interpreting the level coefficient. A negative level estimate in an uncentred model does not, on its own, indicate an immediate fall at the launch.

Time-series standard errors use the default Andrews quadratic-spectral heteroskedasticity-and-autocorrelation-consistent covariance estimator in the R package `sandwich`, through `vcovHAC`. They are not described as Newey–West errors. A separate window sensitivity uses a Bartlett/Newey–West estimator with a three-month lag and no prewhitening. Residual dependence and the short series still limit precision. Interrupted-time-series guidance emphasises the importance of concurrent events, temporal structure and a credible counterfactual [@bernal2017interrupted]. Here the regressions summarise observed trajectories rather than identify an intervention effect.

We also estimate a common-trend model, $Y_t=\alpha+\beta t+\theta P_t+\varepsilon_t$. Its post coefficient imposes a common slope across the boundary and is not the same quantity as either a long-run change or a segmented slope change. Window comparisons use the same model but vary the available pre- and post-periods. Table 7 reports their actual lengths; the longest requested windows are not symmetric because the archive begins in 2021. Holm-adjusted probabilities are shown for the family of window tests. Breakpoint estimates select changes from the observed series; their confidence intervals are conditional on that statistical model and do not establish which historical event caused a break.

For the count series, the Bai–Perron least-squares procedure fits multiple breaks in a linear trend, with a minimum segment fraction of 0.15 and the number of breaks selected by the Bayesian information criterion. Nominal confidence intervals use the 95% default in `strucchange`. Reported break dates follow the package convention: each marks the last month of the preceding segment. These model-based dates need not coincide with the month when a new trajectory begins.

## 4.2. Outlet comparisons and composition

For the tabloid comparison, the preferred linear-probability specification includes outlet and calendar-month fixed effects:

$$D_{it} = \alpha_{o(i)} + \lambda_t + \tau\bigl(P_t\times T_{o(i)}\bigr) + u_{it},$$

where $D_{it}$ is the item-level threat indicator and $T_o$ denotes the tabloid category. The interaction estimates the differential post-period change relative to the comparison category; it is not an absolute decline in tabloid threat language. Standard errors are clustered by outlet and calendar month. With {{DID_OUTLETS}} outlets, only {{DID_TABLOIDS}} in the tabloid category, conventional cluster inference is fragile. Equal outlet-month weights and leave-one-out comparisons assess sensitivity. The earlier custom wild-bootstrap result is not used as verified evidence because its treatment of fixed effects requires independent validation. Small-cluster methods do not remove the need to assess design and model assumptions [@cameronGelbachMiller2008; @mackinnonWebb2017].

To examine composition more directly, we identify named outlets with at least one qualifying item in every observed month, calculate their within-outlet shares, and average them with equal outlet weights. This subset contains {{BALANCED_OUTLETS}} outlets and {{BALANCED_N}} items. It holds outlet identities and weights fixed, while selecting outlets on observed corpus participation. The subset is used as a robustness and interpretation exercise, not as a population-weighted estimate.

## 4.3. Title similarity and engagement

Title similarity uses unique alphabetic tokens of at least four letters, requiring at least three tokens per title. Candidate pairs must be from different sources, within three days, and share one of the two rarest tokens selected from each title. A pair is classified as similar when token-set Jaccard similarity reaches 0.70. Candidate blocking improves computational tractability but can miss similar pairs. The resulting label is “matched title”, not “agency copy”; unmatched items cannot be assumed to be original reporting.

For web items, we regress log of one plus recorded interactions on the threat and opportunity indicators with source and month fixed effects, then use source-by-month effects. We also estimate a log model restricted to positive outcomes and a Poisson pseudo-maximum-likelihood model with source-by-month effects. Source-clustered standard errors allow within-source dependence. Exponentiating a log-one-plus coefficient does not yield a percentage change in expected interaction counts when zeros are present [@chenroth2024]. The outcome also lacks a verified common capture horizon and a demonstrated distinction between genuine zeros and unavailable metrics. These regressions describe association and measurement sensitivity, not audience demand caused by framing.

# 5. Results

## 5.1. Coverage volume after the launch

The pooled segmented model estimates a level change of {{LEVEL}} items at December 2022 ($p={{LEVEL_P}}$) and a slope change of {{SLOPE}} additional items per month for each month elapsed ($p{{SLOPE_P}}$). The first estimate is imprecise; the second describes substantial acceleration in the recorded series. It does not imply that every month gains that many items because of ChatGPT. The web-only model estimates a level change of {{WEB_LEVEL}} items ($p={{WEB_LEVEL_P}}$), showing that a categorical “acceleration without a jump” conclusion is sample-dependent.

{{FIG_VOLUME}}

{{TABLE_VOLUME}}

Data-selected breakpoints occur in {{BREAK_1}} and {{BREAK_2}}, with model-based confidence intervals of {{BREAK_1_LO}}–{{BREAK_1_HI}} and {{BREAK_2_LO}}–{{BREAK_2_HI}}, respectively. The first interval does not contain December 2022. These are descriptive changes in the count series, not proof of a specific diffusion mechanism. A December 2021 placebo fitted only to the pre-launch sample gives level and slope probabilities of {{PLACEBO_LEVEL_P}} and {{PLACEBO_SLOPE_P}}. Failure to detect that placebo is a limited specification check, not validation of the main design.

## 5.2. Risk and skills occupy different shares of a larger discussion

Table 4 distinguishes raw period means from common-trend-adjusted coefficients. The monthly threat share is higher in the post period, while opportunity changes from {{OP_PRE}}% to {{OP_POST}}%. The skills indicator falls by {{SK_CHANGE_ABS}} percentage points in raw monthly means. Its common-trend post coefficient is {{SK_ADJ}} percentage points ($p{{SK_ADJ_P}}$). By contrast, the full-period threat post coefficient is {{TH_ADJ}} percentage points ($p={{TH_ADJ_P}}$), which does not distinguish a discrete launch-associated shift from the fitted trend.

{{FIG_SHARES}}

{{TABLE_INDICATORS}}

The absolute monthly count of skills-matching items increases from {{SK_N_PRE}} to {{SK_N_POST}}. Thus the evidence supports a decline in skills' share of the retrieved discussion, while its recorded volume expands. It does not support the claim that fewer skills-related items were published or that readers encountered less guidance. The dictionary itself does not establish whether a skills reference supplies useful advice. Likewise, approximate stability of a period-average opportunity share should not be read as a flat trajectory throughout the period.

The fixed-outlet analysis sharpens this distinction. In the balanced, equally weighted subset, the threat share changes from {{BAL_TH_PRE}}% to {{BAL_TH_POST}}%, and the skills share from {{BAL_SK_PRE}}% to {{BAL_SK_POST}}%. Table 5 separates risk without skills, skills without risk, their co-occurrence and neither. This makes explicit whether the risk–skills relationship reflects coexistence inside items or a reallocation across different items. These descriptive categories concern word matches; establishing whether risk reporting provides an actionable response requires human coding.

{{TABLE_JOINT}}

## 5.3. Outlet categories and inference

Table 6 aggregates counts and item-weighted indicator shares by outlet type. It provides the composition information needed to interpret comparisons across editorial categories. The residual “other web” category contains heterogeneous sources and should not be treated as a coherent editorial model. Non-web observations combine distinct platforms whose coverage changes over time.

{{TABLE_TYPES}}

In the outlet-and-month fixed-effects model, the tabloid interaction is {{DID_PP}} percentage points (standard error {{DID_SE_PP}}; $p={{DID_P}}$). The negative sign means that the post-period rise in the tabloid category is smaller than in the comparison category, conditional on this specification. It does not mean that tabloids became absolutely less threatening. Equal outlet-month weighting gives {{DID_EQUAL_PP}} percentage points. Leave-one-out estimates range from {{LOO_MIN_PP}} to {{LOO_MAX_PP}} percentage points, with probabilities from {{LOO_MIN_P}} to {{LOO_MAX_P}}. The sign contradicts the simple prediction of a larger tabloid rise, but limited cluster support and specification sensitivity argue against declaring that theory decisively rejected.

## 5.4. Timing and robustness

The window estimates are not a monotonic sequence. The requested eighteen-month window gives {{W18}} percentage points ($p={{W18_P}}$), and the requested twenty-four-month window gives {{W24}} percentage points ($p={{W24_P}}$). The latter uses {{W24_PRE}} pre-period and {{W24_POST}} post-period months. Its Holm-adjusted probability across the reported window family is {{W24_HOLM}}. These exploratory comparisons suggest sensitivity to the time horizon rather than establish a robust delayed treatment effect.

{{TABLE_WINDOWS}}

{{TABLE_SENSITIVITY}}

Excluding the known suspect dates changes the common-trend estimate from {{TH_ADJ}} to {{CLEAN_TH}} percentage points. This small numerical change does not resolve the broader chronology problem because the targeted audit was not a representative date-validation exercise. Web-only, named-outlet and equal-weight estimates answer related but different descriptive questions. Removing fear/resistance from the threat composite also changes its meaning, isolating the more explicitly economic job-loss and inequality components. These checks should be read as a profile of measurement and specification dependence.

## 5.5. Similar titles and recorded interactions

Among titles eligible for the similarity procedure, {{DUP_PRE}}% of pre-launch and {{DUP_POST}}% of post-launch items have a match. Their threat shares are {{DUP_TH_PRE}}% and {{DUP_TH_POST}}%, compared with {{UNMATCH_TH_PRE}}% and {{UNMATCH_TH_POST}}% for unmatched items. Similar-title items therefore have lower threat prevalence in each period, while threat prevalence rises in both groups. These observations neither identify wire-service origin nor rule out a contribution of redistributed stories to the aggregate change.

{{TABLE_ENGAGEMENT}}

The baseline log-one-plus engagement coefficient on threat is {{ENG_BETA}} (standard error {{ENG_SE}}), while the opportunity coefficient is {{ENG_OP_BETA}}. However, the threat coefficient is {{ENG_POS_BETA}} in the positive-outcome log model ($p={{ENG_POS_P}}$) and {{ENG_PPML_BETA}} in the count model ($p={{ENG_PPML_P}}$). Models also retain different samples because of zeros, singleton fixed effects and all-zero groups. The share of web observations with recorded zero interactions rises from {{ZERO_PRE}}% in 2021 to {{ZERO_LAST}}% in the final partial year. Without resolving the meaning and capture timing of those zeros, the evidence does not establish that threat framing raises expected interactions or that reader demand caused the observed content changes.

# 6. Discussion

## 6.1. Interpretation and contribution

The central substantive pattern is a change in the balance of a growing recorded discussion. Risk language occupies a larger share after the launch, and skills language a smaller share, but a single launch dummy does not summarise the whole trajectory. The contrast between relative and absolute skills attention is especially important: journalists can produce more skills-related items while those items become less prominent within the expanding topic. A claim of neglect requires a justified benchmark for adequate coverage and validation of what the articles actually recommend.

The evidence also qualifies a simple tabloid-versus-quality account of technological fear. The point estimates show a larger post-period increase in the comparison category, which is consistent with professional exposure being newsworthy to its audiences. Audience composition is not observed, however, so this remains a possible explanation. Changes in content supply, story selection and international reporting are alternatives. Similarly, a positive coefficient in one engagement model cannot establish a demand mechanism when the relationship is sensitive to the outcome scale and the availability of interaction data.

This case is relevant to research on smaller-language media systems because it demonstrates how longitudinal scale and semantic validity must be considered jointly. Transparent outlet mappings, platform shares, provenance and co-occurrence measures make the description more interpretable. They do not transform the analysed items into a representative census of what Croatian residents read.

## 6.2. Croatian policy relevance

The practical policy question is whether information about occupational uncertainty is connected to accessible forms of adaptation. Croatia already has an institutional route through the Croatian Employment Service (HZZ) voucher system, which supports eligible employed and unemployed adults in acquiring green, digital and other demanded skills. Its programme catalogue and career-guidance service provide concrete resources that labour-market reporting could help readers locate [@hzz2026vouchers]. This is a communication proposal, not an estimated programme effect: reporting could identify which workers a story concerns, what training is relevant, what eligibility conditions apply, and where verified advice is available.

A second useful direction is to distinguish capability claims from realised adoption and employment outcomes. Enterprise surveys and occupational evidence can provide that context; this corpus cannot substitute for them. A third is to code whether risk-focused items offer verifiable routes to training, workplace consultation or explanation of employment-related rights. The EU AI Act's parliamentary adoption and entry into force fall within the extended observation window and are retained as contextual dates, not as separately identified interventions [@europeanparliament2024; @europeancommission2024]. No legal effect or Croatian implementation outcome is inferred from an annotation on a chart.

## 6.3. Limits and requirements for stronger claims

The main unresolved constraints are human validation and chronology. Independent coding should establish whether dictionary matches actually concern AI's labour implications and whether their errors differ across time and outlets. Date checks should compare stored timestamps with publisher metadata in a stratified sample, retaining original values and a documented resolution rule. Correcting the known cases alone would not establish overall validity.

Stronger causal interpretation would require a justified comparison series or a separate design with credible exposure variation, together with valid measurement. For engagement, a common observation horizon, reliable treatment of unavailable metrics and a design addressing topic selection would be necessary. None of these limitations is resolved by small probabilities in the current regressions.

# 7. Conclusion

AI-and-labour coverage expands substantially in the monitored corpus after ChatGPT's release. Its lexical composition shifts toward risk and away from skills in relative terms, while skills-related item counts increase. The evidence does not isolate a causal launch effect, decisively reject an outlet theory, or establish that threat language causes engagement. A more defensible contribution is the documented evolution of labour-related narratives, with explicit separation of counts, shares, outlet composition and measurement uncertainty. The next empirical step is to validate the semantic and temporal measures before making stronger claims about framing or its consequences.

# References

::: {#refs}
:::

# Appendix A. Measurement specification

The conceptual categories below guide interpretation; they are not a validated coding instrument. All expressions are matched as regular expressions against lowercased title and full text, without a proximity requirement linking the expression to an AI or labour term. There is no automatic stemming or negation handling. Listed expressions are alternatives within a dictionary. Corpus entry separately requires passing both retrieval stages described in Section 3.1.

{{DICTIONARY_APPENDIX}}

# Appendix B. Human-validation protocol

Validation should separate corpus relevance from frame measurement. First, coders should decide whether an item substantively discusses AI and work, distinguish news from other genres, and identify the relevant text span. Second, they should code each labour-related narrative and whether it is asserted, questioned, negated or attributed to a speaker. Third, they should code whether any skills reference gives a concrete adaptation option. This avoids treating a passing word match as a complete frame or as actionable guidance.

Use independently working Croatian-language coders who do not see the automated label. Stratify the sample across pre- and post-launch periods, outlet categories and platforms. Include both dictionary-positive and dictionary-negative items, oversampling rare indicators with known inclusion probabilities. Keep a randomly sampled component to estimate corpus prevalence and record sampling weights. A small pilot can refine the codebook, but the final sample size should be chosen to achieve useful precision for the rarest substantively important indicators rather than treating a fixed small total as sufficient for every category.

Before adjudication, report agreement and disagreement by category, alongside an appropriate chance-corrected agreement statistic. Against adjudicated labels, report weighted precision, recall, specificity and uncertainty intervals separately by period and outlet category. Reserve an untouched evaluation subset if the dictionaries are revised. Publish de-identified labels, codebook versions and reproducible sampling code where the data licence permits. Date verification should be a separate annotation field, with publisher timestamp, retrieval timestamp, revision history and unresolved cases distinguished. These are prospective requirements; this working paper does not report completed human validation.

# Appendix C. Data-quality and sensitivity details

## C.1. Chronology checks

{{TABLE_DATES}}

The publisher checks were conducted on 29 September 2026. No record is silently reassigned to an inferred publication date. The baseline retains the supplied date, and the exclusion sensitivity removes the flagged observations. Archived or amended pages may require additional verification. The audit establishes specific inconsistencies; it does not establish that all other dates are correct.

## C.2. Outlet sensitivity

{{TABLE_DID}}

{{TABLE_LOO}}

## C.3. Platform trajectories

{{FIG_PLATFORMS}}

Platform panels show every platform represented in the corpus, including Instagram. Months before the first qualifying item are left unplotted. Later months with no qualifying items are displayed as zero. Platforms without pre-launch observations are excluded from pre/post comparisons.

## C.4. Recorded engagement availability

{{TABLE_ZEROS}}

## C.5. Post-period trends

{{TABLE_POST_SLOPES}}

The post-period slope describes linear movement from December 2022 onward. It differs from the common-trend post coefficient in Table 4 and the slope change in the segmented model. A non-significant slope is not evidence of an unchanged series, and a significant slope is not evidence that the launch caused persistence. Probabilities in this exploratory table are unadjusted.

# Appendix D. Reproducibility and availability

The analysis uses a fingerprinted corpus snapshot and versioned configuration. The R script exports the estimates; the document build draws empirical numbers and figures from these outputs and checks totals, period definitions, composite consistency and stated directions. Software versions and SHA-256 hashes accompany the source. The commercial text corpus is not redistributed; access remains subject to its licence. Computational checks do not establish semantic validity, accurate timestamps or representative readership. Independent human coding remains outstanding.
