# Contributing

Thank you for your interest in contributing to this project. Contributions of
all kinds are welcome: bug reports, improved documentation, additional
analyses, and code enhancements.

## How to contribute

1. **Fork** the repository and create a feature branch from `main`.
2. Make your changes. Follow the existing code style and conventions.
3. Run the pipeline locally to verify nothing is broken: `make all`.
4. Open a **pull request** with a clear description of what you changed and why.

## Code conventions

- All R scripts source `R/00_helpers.R` for configuration and shared functions.
- Parameters and dictionaries live in `config.yml`, not hardcoded in scripts.
- Use `|>` (native pipe) rather than `%>%` where possible.
- Scripts are numbered to indicate execution order.
- Variable names use `snake_case`.

## Adding new frames or actors

1. Add the new dictionary entries to `config.yml`.
2. The analysis script (`R/03_analysis.qmd`) reads dictionaries from config, so
   no code changes are needed unless you want a custom visualization.
3. Update `data/codebook/codebook.md` with the new variable descriptions.

## Reporting issues

Open a [GitHub issue](../../issues) describing:
- What you expected to happen
- What actually happened
- Steps to reproduce (if applicable)
- Your R version and operating system

## Code of conduct

This project adheres to the [Contributor Covenant](CODE_OF_CONDUCT.md). By
participating, you are expected to uphold this code.
