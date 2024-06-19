# SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

# This Makefile is written to work in all language directories and is supposed
# to be symlinked in all directories from a shared location.

.DEFAULT_GOAL := help

lang = $(notdir $(CURDIR))
scripts-dir = ../../scripts
src-text = Ada_Zangemann-$(lang).txt
sla-output = $(lang)-print.sla $(lang)-screen.sla $(lang)-coversoft.sla $(lang)-coverhard.sla
pdf-output = $(sla-output:.sla=.pdf)
reading-output = $(lang)-reading.txt
all-output = $(reading-output) $(sla-output) $(pdf-output)

$(lang)-%.sla: template-%.sla $(src-text)
	./to_scribus.pl $(src-text) template-$*.sla > $(lang)-$*.sla

$(lang)-reading.txt: $(src-text)
	./to_reading.pl $(src-text) > $(reading-output)

%.pdf: %.sla
	$(scripts-dir)/./to_pdf.sh $<

.PHONY: help
help:
	@echo "Use this Makefile to generate output files:" >&2
	@echo "Create a single output file:" >&2
	@echo "  make nl-screen.sla" >&2
	@echo "Create all defined output files:" >&2
	@echo "  make all" >&2
	@echo "Remove output files" >&2
	@echo "  make clean" >&2
	@echo "Print this help output" >&2
	@echo "  make help" >&2
	@echo "All defined output files to make here:" >&2
	@echo "  $(all-output)"

.PHONY: all
all: $(all-output)

.PHONY: clean
clean:
	rm -f $(all-output)

# Command to debug this Makefile
.PHONY: debug
debug:
	@echo lang: $(lang)
	@echo all-output: $(all-output)
