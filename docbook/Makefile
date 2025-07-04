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

# Targets to create split protest pages based on protest pages present
ada-p40s := $(addprefix build/,$(subst ada-p40-41,ada-p40,$(wildcard images/illustrations/ada-p40-41.*.png)))
ada-p41s := $(addprefix build/,$(subst ada-p40-41,ada-p41,$(wildcard images/illustrations/ada-p40-41.*.png)))

# Targets to create rotated spine images
ada-spine-btt := $(addprefix build/,$(subst .ttb.,.btt.,$(wildcard images/illustrations/ada-a01-spine*.ttb.png)))
ada-spine-ttb := $(addprefix build/,$(subst .btt.,.ttb.,$(wildcard images/illustrations/ada-a01-spine*.btt.png)))

# PHONY target for illustrations that includes postprocessing
# TODO: add targets for ttb and btt spine images
.PHONY: build/images/illustrations/all
build/images/illustrations/all: build/images/illustrations $(ada-p40s) $(ada-p41s) $(ada-spine-btt) $(ada-spine-ttb)

# Translation file
po/Ada_Zangemann.pot: Ada_Zangemann.dbk
	itstool -n -o $@ Ada_Zangemann.dbk

# Update .po files when .pot strings get updated
po/%.po: po/Ada_Zangemann.pot
	if [ ! -e $@ ]; then cp po/Ada_Zangemann.pot $@; fi
	msgmerge --update $@ po/Ada_Zangemann.pot

# Generate message strings for further processing.
# Stored alongside .po files to deal with assumptions by tools.
# Use fuzzy entries that might need some more editing.
po/%.mo: po/%.po
	msgfmt --use-fuzzy -o $@ $<

.PHONY: status
status:
	for p in po/*.po; do printf "$$p "; msgfmt -o /dev/null --stat $$p; done

# Derived images
# NOTE: using images from source instead of build directory to prevent ordering conflict
build/images/illustrations/ada-p40.%.png: images/illustrations/ada-p40-41.%.png
	convert $< -crop "3430x3527+0+0" $@

build/images/illustrations/ada-p41.%.png: images/illustrations/ada-p40-41.%.png
	convert $< -gravity East -crop "3430x3527+0+0" $@

# Create spine variants (bottom-to-top and top-to-bottom)
build/images/illustrations/%.btt.png: images/illustrations/%.ttb.png
	convert $< -rotate 180 $@

build/images/illustrations/%.ttb.png: images/illustrations/%.btt.png
	convert $< -rotate 180 $@

# Link illustrations
# NOTE: marked as precious to prevent cleanup of symbolic link
.PRECIOUS: build/images/illustrations
build/images/illustrations:
	mkdir -p build/images/illustrations || exit 0
	cd build/images/illustrations; ln -f -s ../../../images/illustrations/*.png ./

# Link to capitals-opague
# TODO: add separate target for transparent capitals
# NOTE: marked as precious to prevent cleanup of symbolic link
.PRECIOUS: build/images/capitals
build/images/capitals:
	mkdir -p build/images || exit 0
	if [ ! -h $@ ]; then ln -s ../../images/capitals-opague build/images/capitals; fi

# Create docbook files
targets-dbk = $(addprefix build/Ada_Zangemann.,$(addsuffix .dbk,$(translations)))
$(targets-dbk): build/Ada_Zangemann.%.dbk: po/%.mo Ada_Zangemann.dbk
	itstool --strict --merge $< --out $@ Ada_Zangemann.dbk

# Create 'pure' docbook files without custom elements
build/Ada_Zangemann-pure.%.dbk: build/Ada_Zangemann.%.dbk xsl/clean-docbook.xsl
	xsltproc -o $@ xsl/clean-docbook.xsl $<

# Profile docbook for text processing
# Relies on XSLT 1.0 stylesheets https://github.com/docbook/xslt10-stylesheets/ included in Debian docbook-xsl package
# FIXME: returns exit code 6 'Error in one of the documents' without a clear issue or error in output.
build/Ada_Zangemann-pure-profiled-text.%.dbk: build/Ada_Zangemann-pure.%.dbk
	xsltproc -o $@ --verbose /usr/share/xml/docbook/stylesheet/docbook-xsl/profiling/profile.xsl --stringparam profile.condition "headings-text;capitals-text;colophon-simple" $< > $@.log 2>&1 || exit 0

# HTML output using standard docbook processing
# TODO: use lower resolution images
# FIXME: warning 'No localization exists for "ada_zangemann" or "ada". Using default "en".'
# Relies on XSLT 1.0 stylesheets https://github.com/docbook/xslt10-stylesheets/ included in Debian docbook-xsl package
targets-html = $(addprefix build/Ada_Zangemann.,$(addsuffix .html,$(translations)))
$(targets-html): build/Ada_Zangemann.%.html: build/Ada_Zangemann-pure-profiled-text.%.dbk build/images/illustrations/all
	xsltproc -o $@ /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl $<

.PHONY: build/Ada_Zangemann.all.html
build/Ada_Zangemann.all.html: $(targets-html)

# LaTeX based pdf processing
# FIXME: not yet working
build/Ada_Zangemann-dblatex.%.pdf: build/Ada_Zangemann-pure-profiled-text.%.dbk build/images/illustrations/all
	dblatex -o $@ $<

# Epub processing
targets-dbtoepub = $(addprefix build/Ada_Zangemann-dbtoepub.,$(addsuffix .epub,$(translations)))
$(targets-dbtoepub): build/Ada_Zangemann-dbtoepub.%.epub: build/Ada_Zangemann-pure-profiled-text.%.dbk
	dbtoepub -o $@ $<
	epubcheck $@

.PHONY: build/Ada_Zangemann-dbtoepub.all.epub
build/Ada_Zangemann-dbtoepub.all.epub: $(targets-dbtoepub)

# Pandoc markdown
targets-pandoc-md = $(addprefix build/Ada_Zangemann-pandoc.,$(addsuffix .md,$(translations)))
$(targets-pandoc-md): build/Ada_Zangemann-pandoc.%.md: build/Ada_Zangemann-pure-profiled-text.%.dbk build/images/illustrations/all
	pandoc -f docbook -o $@ $<

.PHONY: build/Ada_Zangemann-pandoc.all.md
build/Ada_Zangemann-pandoc.all.md: $(targets-pandoc-md)

# Build version with all images (for debugging)
build/Ada_Zangemann-print-all.%.sla: build/Ada_Zangemann.%.dbk build/images/illustrations/all build/images/capitals xsl/scribus.xsl
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "colophon-simple" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

# Build version with image headers
targets-print-headings-img = $(addprefix build/Ada_Zangemann-print-headings-img.,$(addsuffix .sla,$(translations)))
$(targets-print-headings-img): build/Ada_Zangemann-print-headings-img.%.sla: build/Ada_Zangemann.%.dbk build/images/illustrations/all build/images/capitals xsl/scribus.xsl
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "headings-img;capitals-img;colophon-simple" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

.PHONY: build/Ada_Zangemann-print-headings-img.all.sla
build/Ada_Zangemann-print-headings-img.all.sla: $(targets-print-headings-img)

targets-print-headings-img-colophon-print = $(addprefix build/Ada_Zangemann-print-headings-img-colophon-print.,$(addsuffix .sla,$(translations)))
$(targets-print-headings-img-colophon-print): build/Ada_Zangemann-print-headings-img-colophon-print.%.sla: build/Ada_Zangemann.%.dbk build/images/illustrations/all build/images/capitals xsl/scribus.xsl
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "headings-img;capitals-img;colophon-print" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

.PHONY: build/Ada_Zangemann-print-headings-img-colophon-print.all.sla
build/Ada_Zangemann-print-headings-img-colophon-print.all.sla: $(targets-print-headings-img-colophon-print)

# Build version with text headers
targets-print-headings-text = $(addprefix build/Ada_Zangemann-print-headings-text.,$(addsuffix .sla,$(translations)))
$(targets-print-headings-text): build/Ada_Zangemann-print-headings-text.%.sla: build/Ada_Zangemann.%.dbk build/images/illustrations/all build/images/capitals xsl/scribus.xsl
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "headings-text;capitals-text;colophon-simple" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

.PHONY: build/Ada_Zangemann-print-headings-text.all.sla
build/Ada_Zangemann-print-headings-text.all.sla: $(targets-print-headings-text)

targets-print-headings-text-colophon-print = $(addprefix build/Ada_Zangemann-print-headings-text-colophon-print.,$(addsuffix .sla,$(translations)))
$(targets-print-headings-text-colophon-print): build/Ada_Zangemann-print-headings-text-colophon-print.%.sla: build/Ada_Zangemann.%.dbk build/images/illustrations/all build/images/capitals xsl/scribus.xsl
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "headings-text;capitals-text;colophon-print" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

.PHONY: build/Ada_Zangemann-print-headings-text-colophon-print.all.sla
build/Ada_Zangemann-print-headings-text-colophon-print.all.sla: $(targets-print-headings-text-colophon-print)

# Build version with text subtitle
targets-coverhard-text = $(addprefix build/Ada_Zangemann-coverhard-text.,$(addsuffix .sla,$(translations)))
$(targets-coverhard-text): build/Ada_Zangemann-coverhard-text.%.sla: build/Ada_Zangemann.%.dbk build/images/illustrations/all build/images/capitals xsl/scribus.xsl
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition "capitals-text;cover-print-text;colophon-simple" xsl/scribus.xsl templates/template-coverhard.sla > $@.log 2>&1

# Build version with no conditional content (for debugging)
build/Ada_Zangemann-print-headings-none.%.sla: build/Ada_Zangemann.%.dbk build/images/illustrations/all build/images/capitals xsl/scribus.xsl
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition ";colophon-simple" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

# TODO: add autocompletion for these pdf conversions
%.pdf: %.sla
	../scripts/./to_pdf.sh $<

# Create a pdf with low quality images for file size of about 1,5MB
%.lowres.pdf: %.pdf
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -o $@ $<

# Create a pdf with medium quality images for file size of about 4MB
%.mediumres.pdf: %.pdf
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -o $@ $<

# Create a textfile from the pdf, intended for verification like spellcheck
%.pdf.txt: %.pdf
	pdftotext $< $@

# Format docbook file using xmllint
.PHONY: xmllint-format
xmllint-format: Ada_Zangemann.dbk
	mv Ada_Zangemann.dbk Ada_Zangemann.dbk.xmllintbak
	xmllint --format Ada_Zangemann.dbk.xmllintbak > Ada_Zangemann.dbk

.PHONY: targets-all-scribus
targets-all-scribus: build/Ada_Zangemann-print-headings-img.all.sla build/Ada_Zangemann-print-headings-img-colophon-print.all.sla build/Ada_Zangemann-print-headings-text.all.sla build/Ada_Zangemann-print-headings-text-colophon-print.all.sla

.PHONY: targets-all
targets-all: targets-all-scribus build/Ada_Zangemann.all.html build/Ada_Zangemann-pandoc.all.md build/Ada_Zangemann-dbtoepub.all.epub

.PHONY: all
all: $(targets-all)

targets-all-po = $(addprefix po/,$(addsuffix .po,$(translations)))
.PHONY: update
update: po/Ada_Zangemann.pot $(targets-all-po)

# Remove build output
.PHONY: clean
clean:
	rm -r build/ || exit 0

# Print obsolete translations no longer matching source strings
.PHONY: check-obsolete
check-obsolete:
	grep -e '^#~' po/*.po

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
