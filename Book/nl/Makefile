# SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

.DEFAULT_GOAL := help

sla-output = nl-print.sla nl-screen.sla nl-coversoft.sla nl-coverhard.sla

nl-%.sla: template-%.sla Ada_Zangemann-nl.txt
	./to_scribus.pl Ada_Zangemann-nl.txt template-$*.sla > nl-$*.sla

nl-reading.txt: Ada_Zangemann-nl.txt
	./to_reading.pl Ada_Zangemann-nl.txt > nl-reading.txt

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
all: $(sla-output) nl-reading.txt

.PHONY: clean
clean:
	rm $(sla-output)





