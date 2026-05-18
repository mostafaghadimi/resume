# Makefile for building the LaTeX resume.
#
# Quick usage:
#   make           Build resume.pdf (one shot, with reruns as needed).
#   make watch     Continuously rebuild resume.pdf when sources change.
#   make clean     Remove auxiliary build files (keep the PDF).
#   make distclean Remove the PDF too.
#   make help      Print this help.

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
MAIN          := resume
TEX_ENGINE    := xelatex
LATEXMK       := latexmk
LATEXMK_FLAGS := -$(TEX_ENGINE) -interaction=nonstopmode -halt-on-error -file-line-error -shell-escape

# All source files we depend on. Used so `make` knows when to rebuild.
SOURCES := $(MAIN).tex russell.cls $(wildcard cv/*.tex)

# -----------------------------------------------------------------------------
# Targets
# -----------------------------------------------------------------------------
.PHONY: all build watch clean distclean check help

all: build

build: $(MAIN).pdf

$(MAIN).pdf: $(SOURCES)
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN).tex

watch:
	$(LATEXMK) $(LATEXMK_FLAGS) -pvc $(MAIN).tex

# Remove latexmk's intermediate files but keep the PDF.
clean:
	$(LATEXMK) -c $(MAIN).tex
	@rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz *.bbl *.bcf *.run.xml *.blg *.xdv

# Full clean: also delete the PDF.
distclean: clean
	$(LATEXMK) -C $(MAIN).tex
	@rm -f $(MAIN).pdf

# Sanity check: confirm xelatex and latexmk are installed.
check:
	@command -v $(TEX_ENGINE) >/dev/null 2>&1 || { echo "error: $(TEX_ENGINE) not found in PATH"; exit 1; }
	@command -v $(LATEXMK)    >/dev/null 2>&1 || { echo "error: $(LATEXMK) not found in PATH"; exit 1; }
	@echo "OK: $(TEX_ENGINE) and $(LATEXMK) are available."

help:
	@echo "Available targets:"
	@echo "  make            Build $(MAIN).pdf (default)"
	@echo "  make watch      Rebuild $(MAIN).pdf continuously when sources change"
	@echo "  make clean      Remove LaTeX aux files (keep PDF)"
	@echo "  make distclean  Remove LaTeX aux files AND the PDF"
	@echo "  make check      Verify TeX toolchain is installed"
