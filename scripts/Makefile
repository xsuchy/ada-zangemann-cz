# SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

# This Makefile is written to work in all language directories and is supposed
# to be symlinked in all directories from a shared location.

.DEFAULT_GOAL := help

lang = $(notdir $(CURDIR))
src-text = Ada_Zangemann-$(lang).txt
sla-output = $(lang)-print.sla $(lang)-screen.sla $(lang)-coversoft.sla $(lang)-coverhard.sla
reading-output = $(lang)-reading.txt
all-output = $(sla-output) $(reading-output)

$(lang)-%.sla: template-%.sla $(src-text)
	./to_scribus.pl $(src-text) template-$*.sla > $(lang)-$*.sla

$(lang)-reading.txt: $(src-text)
	./to_reading.pl $(src-text) > $(reading-output)

.PHONY: debug
debug:
	@echo $(CURDIR)
	@echo $(notdir $(CURDIR))
	@echo $(sla-output)

.PHONY: help
help:
	@echo "Use this Makefile to generate output files:" >&2
	@echo "Create a single output file:" >&2
	@echo "  make nl-screen.sla" >&2
	@echo "Create all output files:" >&2
	@echo "  make all" >&2
	@echo "Remove output files" >&2
	@echo "  make clean" >&2
	@echo "Print this help output" >&2
	@echo "  make help" >&2

.PHONY: all
all: $(all-output)

.PHONY: clean
clean:
	rm -f $(all-output)
