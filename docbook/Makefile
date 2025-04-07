# SPDX-FileCopyrightText: 2024-2025 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

# GNU Make is used to automate the creation of various output formats. Each rule
# defines the output and prerequisites. This way files only get created if
# needed and files only get updated if a prerequisite was updated. More
# information is available in the GNU Make manual:
# https://www.gnu.org/software/make/manual/

# Summary of variables used:
# $@    The file name of the target.
# $<    The name of the first prerequisite.
# $(@D) The directory part of $@.
# $(@F) The file-within-directory part of $@.

# Ensure default shell
SHELL = /bin/sh

# FIXME: use $(srcdir) best practice https://www.gnu.org/software/make/manual/html_node/Makefile-Basics.html

# Use existing po translations as base to generate pattern rule targets for autocomplete
translations = $(notdir $(basename $(wildcard po/*.po)))

# Translation file
po/Ada_Zangemann.pot: Ada_Zangemann.dbk
	itstool -n -o $@ Ada_Zangemann.dbk

# Update .po files when .pot strings get updated
po/%.po: po/Ada_Zangemann.pot
	if [ ! -e $@ ]; then cp po/Ada_Zangemann.pot $@; fi
	msgmerge --no-wrap --update $@ po/Ada_Zangemann.pot

# Generate message strings for further processing
# Stored alongside .po files to deal with assumptions by tools
po/%.mo: po/%.po
	msgfmt -o $@ $<

status:
	for p in po/*.po; do printf "$$p "; msgfmt -o /dev/null --stat $$p; done


# Link images
# TODO: simplify variable handling to extract language code
# Available images can be collected using wildcard and basepath expressions in Make
# Vpath can be used to resolve location with different fallback paths
# NOTE: marked as precious to prevent cleanup of symbolic link
.PRECIOUS: build/%/images/illustrations
build/%/images/illustrations:
	mkdir -p $(@D) || exit 0
	makefile_helpers/./imagedir.sh $(shell echo ${@} | sed -n 's/.*build\/\(.*\)\/images.*/\1/p')

# Link to capitals-opague
# TODO: add separate target for transparent capitals
# NOTE: marked as precious to prevent cleanup of symbolic link
.PRECIOUS: build/%/images/capitals
build/%/images/capitals:
	mkdir -p $(@D)
	if [ ! -h $@ ]; then ln -s ../../../images/capitals-opague $@; fi

# Create docbook files
targets-dbk = $(addprefix build/,$(addsuffix /Ada_Zangemann.dbk,$(translations)))
$(targets-dbk): build/%/Ada_Zangemann.dbk: po/%.mo Ada_Zangemann.dbk
	mkdir -p $(@D) || exit 0
	itstool -m $< -o $(@D) $(@F)

# Create 'pure' docbook files without custom elements
build/%/Ada_Zangemann-pure.dbk: build/%/Ada_Zangemann.dbk xsl/clean-docbook.xsl
	xsltproc -o $@ xsl/clean-docbook.xsl $<

# Profile docbook for text processing
# Relies on XSLT 1.0 stylesheets https://github.com/docbook/xslt10-stylesheets/ included in Debian docbook-xsl package
# FIXME: returns exit code 6 'Error in one of the documents' without a clear issue or error in output.
build/%/Ada_Zangemann-pure-profiled-text.dbk: build/%/Ada_Zangemann-pure.dbk
	xsltproc -o $@ --verbose /usr/share/xml/docbook/stylesheet/docbook-xsl/profiling/profile.xsl --stringparam profile.condition "headings-text;capitals-text" $< > $@.log 2>&1 || exit 0

# HTML output using standard docbook processing
# TODO: use lower resolution images
# FIXME: warning 'No localization exists for "ada_zangemann" or "ada". Using default "en".'
# Relies on XSLT 1.0 stylesheets https://github.com/docbook/xslt10-stylesheets/ included in Debian docbook-xsl package
targets-html = $(addprefix build/,$(addsuffix /Ada_Zangemann.html,$(translations)))
$(targets-html): build/%/Ada_Zangemann.html: build/%/Ada_Zangemann-pure-profiled-text.dbk build/%/images/illustrations
	xsltproc -o $@ /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl $<

.PHONY: build/all/Ada_Zangemann.html
build/all/Ada_Zangemann.html: $(targets-html)

# LaTeX based pdf processing
# FIXME: not yet working
build/%/Ada_Zangemann-dblatex.pdf: build/%/Ada_Zangemann-pure-profiled-text.dbk build/%/images/illustrations
	dblatex -o $@ $<

# Epub processing
build/%/Ada_Zangemann-dbtoepub.epub: build/%/Ada_Zangemann-pure-profiled-text.dbk
	dbtoepub -o $@ $<
	epubcheck $@

# Pandoc markdown
targets-pandoc-md = $(addprefix build/,$(addsuffix /Ada_Zangemann-pandoc.md,$(translations)))
$(targets-pandoc-md): build/%/Ada_Zangemann-pandoc.md: build/%/Ada_Zangemann-pure.dbk build/%/images/illustrations
	pandoc -f docbook -o $@ $<

.PHONY: build/all/Ada_Zangemann-pandoc.md
build/all/Ada_Zangemann-pandoc.md: $(targets-pandoc-md)

# Build version with all images (for debugging)
build/%/print-all/Ada_Zangemann-print-all.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations build/%/images/capitals xsl/scribus.xsl
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

# Build version with image headers
targets-print-headings-img = $(addprefix build/,$(addsuffix /print-headings-img/Ada_Zangemann-print-headings-img.sla,$(translations)))
$(targets-print-headings-img): build/%/print-headings-img/Ada_Zangemann-print-headings-img.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations build/%/images/capitals xsl/scribus.xsl
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "headings-img;capitals-img" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

.PHONY: build/all/print-headings-img/Ada_Zangemann-print-headings-img.sla
build/all/print-headings-img/Ada_Zangemann-print-headings-img.sla: $(targets-print-headings-img)

# Build version with text headers
targets-print-headings-text = $(addprefix build/,$(addsuffix /print-headings-text/Ada_Zangemann-print-headings-text.sla,$(translations)))
$(targets-print-headings-text): build/%/print-headings-text/Ada_Zangemann-print-headings-text.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations build/%/images/capitals xsl/scribus.xsl
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "headings-text;capitals-text" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

.PHONY: build/all/print-headings-text/Ada_Zangemann-print-headings-text.sla
build/all/print-headings-text/Ada_Zangemann-print-headings-text.sla: $(targets-print-headings-text)

# Build version with text subtitle
targets-coverhard-text = $(addprefix build/,$(addsuffix /coverhard-text/Ada_Zangemann-coverhard-text.sla,$(translations)))
$(targets-coverhard-text): build/%/coverhard-text/Ada_Zangemann-coverhard-text.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations build/%/images/capitals xsl/scribus.xsl
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "capitals-text;cover-print-text" xsl/scribus.xsl templates/template-coverhard.sla > $@.log 2>&1

targets-coverhard-img = $(addprefix build/,$(addsuffix /coverhard-img/Ada_Zangemann-coverhard-img.sla,$(translations)))
$(targets-coverhard-img): build/%/coverhard-img/Ada_Zangemann-coverhard-img.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations build/%/images/capitals xsl/scribus.xsl
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "capitals-img;cover-print-img" xsl/scribus.xsl templates/template-coverhard.sla > $@.log 2>&1

# Build version with no conditional content (for debugging)
build/%/print-headings-none/Ada_Zangemann-print-headings-none.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations build/%/images/capitals xsl/scribus.xsl
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition ";" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

# TODO: add autocompletion for these pdf conversions
%.pdf: %.sla
	../scripts/./to_pdf.sh $<

# Link template files, for development
# TODO: check, does this work correctly?
build/%/template-print.sla:
	mkdir -p $(@D) || exit 0
	if [ ! -h $@ ]; then ln -s ../../templates/template-print.sla $@; fi

build/%/template-coverhard.sla:
	mkdir -p $(@D) || exit 0
	if [ ! -h $@ ]; then ln -s ../../templates/template-coverhard.sla $@; fi

# Format docbook file using xmllint
.PHONY: xmllint-format
xmllint-format: Ada_Zangemann.dbk
	mv Ada_Zangemann.dbk Ada_Zangemann.dbk.xmllintbak
	xmllint --format Ada_Zangemann.dbk.xmllintbak > Ada_Zangemann.dbk

targets-scribus = build/%/print-all/Ada_Zangemann-print-all.sla build/%/print-headings-text/Ada_Zangemann-print-headings-text.sla build/%/print-headings-none/Ada_Zangemann-print-headings-none.sla

targets-all-scribus = $(addprefix build/,$(addsuffix /all-scribus,$(translations)))
.PHONY: build/%/all-scribus
$(targets-all-scribus): build/%/all-scribus: $(targets-scribus)

targets-all = $(addprefix build/,$(addsuffix /all,$(translations)))
.PHONY: build/%/all
$(targets-all): build/%/all: build/%/all-scribus build/%/Ada_Zangemann-pure.dbk build/%/Ada_Zangemann.html build/%/Ada_Zangemann-dblatex.pdf build/%/Ada_Zangemann-dbtoepub.epub build/%/Ada_Zangemann-pandoc.md

.PHONY: all
all: $(targets-all)

targets-all-po = $(addprefix po/,$(addsuffix .po,$(translations)))
.PHONY: update
update: po/Ada_Zangemann.po $(targets-all-po)

# Remove build output
.PHONY: clean
clean:
	rm -r build/

# Validation commands (work in progress)
# TODO; not yet working
docbook-5.1-its.sch:
	wget -O docbook-5.1-its.sch http://docs.oasis-open.org/docbook/docbook/v5.1/os/schemas/sch/docbookxi.sch

docbook-5.1-its.rng:
	wget -O docbook-5.1-its.rng http://docs.oasis-open.org/docbook/docbook/v5.1/os/schemas/rng/dbits.rng

docbook-5.2.rng:
	wget -O docbook-5.2.rng https://docs.oasis-open.org/docbook/docbook/v5.2/os/rng/docbookxi.rng

.PHONY: validate
validate: docbook-5.1-its.rng docbook-5.1-its.sch Ada_Zangemann-en.dbk
	xmllint --noout --relaxng docbook-5.1-its.rng Ada_Zangemann-en.dbk
	xmllint --noout --schematron docbook-5.1-its.sch Ada_Zangemann-en.dbk
