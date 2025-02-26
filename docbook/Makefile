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

# Translation file
po/Ada_Zangemann.pot: Ada_Zangemann.dbk
	itstool -o $@ Ada_Zangemann.dbk

# Update .po files when .pot strings get updated
po/%.po: po/Ada_Zangemann.pot
	if [ ! -e $@ ]; then cp po/Ada_Zangemann.pot $@; fi
	msgmerge --no-wrap --update $@ po/Ada_Zangemann.pot

# Generate message strings for further processing
build/%/Ada_Zangemann.mo: po/%.po
	mkdir -p $(@D)
	msgfmt -o $@ $<

# Link images
# TODO: simplify variable handling to extract language code
# Available images can be collected using wildcard and basepath expressions in Make
# Vpath can be used to resolve location with different fallback paths
build/%/images/illustrations:
	makefile_helpers/./imagedir.sh $(shell echo ${@} | sed -n 's/.*build\/\(.*\)\/images.*/\1/p')

# Create docbook files
build/%/Ada_Zangemann.dbk: build/%/Ada_Zangemann.mo Ada_Zangemann.dbk
	itstool -m $< -o $(@D) $(@F)

# Create 'pure' docbook files without custom elements
build/%/Ada_Zangemann-pure.dbk: build/%/Ada_Zangemann.dbk xsl/clean-docbook.xsl
	xsltproc -o $@ xsl/clean-docbook.xsl $<

# HTML output using standard docbook processing
# TODO: use lower resolution images
# FIXME: warning 'No localization exists for "ada_zangemann" or "ada". Using default "en".'
build/%/Ada_Zangemann.html: build/%/Ada_Zangemann-pure.dbk
	xsltproc -o $@ /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl $<

# LaTeX based pdf processing
# FIXME: not yet working
build/%/Ada_Zangemann-dblatex.pdf: build/%/Ada_Zangemann-pure.dbk build/%/images/illustrations
	dblatex -o $@ $<

# Epub processing
build/%/Ada_Zangemann-dbtoepub.epub: build/%/Ada_Zangemann-pure.dbk build/%/images/illustrations
	dbtoepub -o $@ $<

# Build version with all images (for debugging)
build/%/print-all/Ada_Zangemann-print-all.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

# Build version with image headers
build/%/print-headings-img/Ada_Zangemann-print-headings-img.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition headings-img xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

# Build version with text headers
build/%/print-headings-text/Ada_Zangemann-print-headings-text.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition headings-text xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

# Build version with no conditional content (for debugging)
build/%/print-headings-none/Ada_Zangemann-print-headings-none.sla: build/%/Ada_Zangemann.dbk build/%/images/illustrations
	mkdir -p $(@D)
	if [ ! -h $(@D)/images ]; then ln -s ../images $(@D)/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../$< --stringparam profile.condition ";" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

# Link template files, for development
build/%/template-print.sla:
	if [ ! -h $@ ]; then ln -s ../../templates/template-print.sla $@; fi

# Format docbook file using xmllint
.PHONY: xmllint-format
xmllint-format: Ada_Zangemann.dbk
	mv Ada_Zangemann.dbk Ada_Zangemann.dbk.xmllintbak
	xmllint --format Ada_Zangemann.dbk.xmllintbak > Ada_Zangemann.dbk

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
