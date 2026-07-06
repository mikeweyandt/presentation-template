# The University of Akron — Marp presentation build
# Run these inside the devcontainer (Marp CLI + Chromium are preinstalled).

MARP       ?= marp
SRC        ?= presentation.md
THEME_DIR  ?= themes

PDF  := $(SRC:.md=.pdf)
PPTX := $(SRC:.md=.pptx)
HTML := $(SRC:.md=.html)

# --theme-set   register the custom Akron theme by name
# --html        allow raw HTML (used for the two-column layout helper)
# --allow-local-files  permit local images/logos when exporting to PDF/PPTX
MARP_FLAGS := --theme-set $(THEME_DIR) --html --allow-local-files

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@echo "The University of Akron — Marp presentation"
	@echo
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[1m%-10s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "Override the source file with:  make pdf SRC=mydeck.md"

.PHONY: pdf
pdf: $(PDF) ## Build a PDF

.PHONY: pptx
pptx: $(PPTX) ## Build a PowerPoint (.pptx)

.PHONY: html
html: $(HTML) ## Build a standalone HTML deck

.PHONY: all
all: pdf pptx ## Build both PDF and PPTX

.PHONY: watch
watch: ## Live preview with hot reload at http://localhost:8080
	$(MARP) $(MARP_FLAGS) --server --watch .

.PHONY: clean
clean: ## Remove generated PDF/PPTX/HTML
	rm -f $(PDF) $(PPTX) $(HTML)

$(PDF): $(SRC) $(wildcard $(THEME_DIR)/*.css)
	$(MARP) $(MARP_FLAGS) --pdf $(SRC) -o $@

$(PPTX): $(SRC) $(wildcard $(THEME_DIR)/*.css)
	$(MARP) $(MARP_FLAGS) --pptx $(SRC) -o $@

$(HTML): $(SRC) $(wildcard $(THEME_DIR)/*.css)
	$(MARP) $(MARP_FLAGS) $(SRC) -o $@
