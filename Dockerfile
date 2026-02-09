# ==============================================================================
# Dockerfile — Reproducible environment for the AI & Labour analysis
# ==============================================================================
# Build:  docker build -t ai-labour .
# Run:    docker run --rm -v "$(pwd)/output:/app/output" ai-labour
# ==============================================================================

FROM rocker/r-ver:4.3.2

LABEL maintainer="Luka Sikic"
LABEL description="Reproducible environment for AI & Labour Market media analysis"

# System dependencies for R packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libicu-dev \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install Quarto
RUN curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.553/quarto-1.4.553-linux-amd64.deb \
    && dpkg -i quarto-1.4.553-linux-amd64.deb \
    && rm quarto-1.4.553-linux-amd64.deb

# Install R packages
RUN R -e 'install.packages(c( \
    "yaml", "DBI", "duckdb", "dplyr", "tidyr", "stringr", "stringi", \
    "lubridate", "forcats", "tibble", "ggplot2", "scales", "patchwork", \
    "ggrepel", "knitr", "kableExtra", "rmarkdown", "quanteda", \
    "quanteda.textstats", "tidytext" \
  ), repos = "https://cloud.r-project.org/")'

WORKDIR /app
COPY . /app

# Default: render the analysis report
CMD ["make", "report"]
