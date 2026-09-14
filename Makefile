# The University of Akron — Marp presentation build
# Run these inside the devcontainer (Marp CLI + Chromium are preinstalled).

MARP       ?= marp
SRC        ?= presentation.md
THEME_DIR  ?= themes

PDF     := $(SRC:.md=.pdf)
PPTX    := $(SRC:.md=.pptx)
HTML    := $(SRC:.md=.html)
HANDOUT := $(SRC:.md=-handout.pdf)

# Light, print-friendly theme used by the `handout` target. Passed with
# marp's --theme flag, which overrides the deck's front matter, so any deck
# can be printed light without editing it.
HANDOUT_THEME ?= akron-cs-handout

# --theme-set   register the custom Akron theme by name
# --html        allow raw HTML (used for the two-column layout helper)
# --allow-local-files  permit local images/logos when exporting to PDF/PPTX
# --browser/--browser-path  pin browser resolution to the one the Dockerfile
#               installed for this architecture (default is --browser auto)
MARP_FLAGS := --theme-set $(THEME_DIR) --html --allow-local-files \
              --browser chrome --browser-path /usr/local/bin/marp-browser

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

.PHONY: handout
handout: $(HANDOUT) ## Build a light, print-friendly PDF (any theme)

.PHONY: watch
watch: ## Live preview with hot reload at http://localhost:8080
	$(MARP) $(MARP_FLAGS) --server --watch .

.PHONY: clean
clean: ## Remove generated PDF/PPTX/HTML
	rm -f $(PDF) $(PPTX) $(HTML) $(HANDOUT)

$(PDF): $(SRC) $(wildcard $(THEME_DIR)/*.css)
	$(MARP) $(MARP_FLAGS) --pdf $(SRC) -o $@

$(PPTX): $(SRC) $(wildcard $(THEME_DIR)/*.css)
	$(MARP) $(MARP_FLAGS) --pptx $(SRC) -o $@

$(HTML): $(SRC) $(wildcard $(THEME_DIR)/*.css)
	$(MARP) $(MARP_FLAGS) $(SRC) -o $@

# The dark akron-cs theme stays the default in every other output, including
# .pptx: marp renders PowerPoint by screenshotting slides under an emulated
# *print* media type, so a @media print rule in the theme would silently
# lighten the deck as well as the handout. Overriding the theme here keeps
# that switch explicit.
$(HANDOUT): $(SRC) $(wildcard $(THEME_DIR)/*.css)
	$(MARP) $(MARP_FLAGS) --theme $(HANDOUT_THEME) --pdf $(SRC) -o $@
