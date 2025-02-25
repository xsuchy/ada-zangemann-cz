# SPDX-FileCopyrightText: 2024-2025 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0


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
# TODO: simplify variable handling
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
build/en/Ada_Zangemann-dblatex.en.pdf: build/en/images/illustrations build/en/Ada_Zangemann-pure.dbk
	dblatex -o build/en/Ada_Zangemann-dblatex.en.pdf build/en/Ada_Zangemann-pure.dbk

build/de/Ada_Zangemann-dblatex.de.pdf: build/de/images/illustrations build/de/Ada_Zangemann-pure.dbk
	dblatex -o build/de/Ada_Zangemann-dblatex.de.pdf build/de/Ada_Zangemann-pure.dbk

build/es/Ada_Zangemann-dblatex.es.pdf: build/es/images/illustrations build/es/Ada_Zangemann-pure.dbk
	dblatex -o build/es/Ada_Zangemann-dblatex.es.pdf build/es/Ada_Zangemann-pure.dbk


# Epub processing
build/en/Ada_Zangemann-dbtoepub.epub: build/en/images/illustrations build/en/Ada_Zangemann-pure.dbk
	dbtoepub -o build/en/Ada_Zangemann-dbtoepub.en.epub build/en/Ada_Zangemann-pure.dbk

build/de/Ada_Zangemann-dbtoepub.epub: build/de/images/illustrations build/de/Ada_Zangemann-pure.dbk
	dbtoepub -o build/de/Ada_Zangemann-dbtoepub.de.epub build/de/Ada_Zangemann-pure.dbk

build/es/Ada_Zangemann-dbtoepub.epub: build/es/images/illustrations build/es/Ada_Zangemann-pure.dbk
	dbtoepub -o build/es/Ada_Zangemann-dbtoepub.es.epub build/es/Ada_Zangemann-pure.dbk


# Build version with all images (for debugging)
build/en/print-all/Ada_Zangemann-print-all.en.sla: build/en/images/illustrations build/en/Ada_Zangemann.dbk
	mkdir -p build/en/print-all
	if [ ! -h build/en/print-all/images ]; then ln -s ../images build/en/print-all/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.dbk xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/de/print-all/Ada_Zangemann-print-all.de.sla: build/de/images/illustrations build/de/Ada_Zangemann.dbk
	mkdir -p build/de/print-all
	if [ ! -h build/de/print-all/images ]; then ln -s ../images build/de/print-all/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/de/Ada_Zangemann.dbk xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/es/print-all/Ada_Zangemann-print-all.es.sla: build/es/images/illustrations build/es/Ada_Zangemann.dbk
	mkdir -p build/es/print-all
	if [ ! -h build/es/print-all/images ]; then ln -s ../images build/es/print-all/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/es/Ada_Zangemann.dbk xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1


# Build version with image headers
build/en/headings-img/Ada_Zangemann-headings-img.en.sla: build/en/images/illustrations build/en/Ada_Zangemann.dbk
	mkdir -p build/en/headings-img
	if [ ! -h build/en/headings-img/images ]; then ln -s ../images build/en/headings-img/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.dbk --stringparam profile.condition headings-img xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/de/headings-img/Ada_Zangemann-headings-img.de.sla: build/de/images/illustrations build/de/Ada_Zangemann.dbk
	mkdir -p build/de/headings-img
	if [ ! -h build/de/headings-img/images ]; then ln -s ../images build/de/headings-img/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/de/Ada_Zangemann.dbk --stringparam profile.condition headings-img xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/es/headings-img/Ada_Zangemann-headings-img.es.sla: build/es/images/illustrations build/es/Ada_Zangemann.dbk
	mkdir -p build/es/headings-img
	if [ ! -h build/es/headings-img/images ]; then ln -s ../images build/es/headings-img/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/es/Ada_Zangemann.dbk --stringparam profile.condition headings-img xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1


# Build version with text headers
build/en/headings-text/Ada_Zangemann-headings-text.en.sla: build/en/images/illustrations build/en/Ada_Zangemann.dbk
	mkdir -p build/en/headings-text
	if [ ! -h build/en/headings-text/images ]; then ln -s ../images build/en/headings-text/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.dbk --stringparam profile.condition headings-text xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/de/headings-text/Ada_Zangemann-headings-text.de.sla: build/de/images/illustrations build/de/Ada_Zangemann.dbk
	mkdir -p build/de/headings-text
	if [ ! -h build/de/headings-text/images ]; then ln -s ../images build/de/headings-text/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/de/Ada_Zangemann.dbk --stringparam profile.condition headings-text xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/es/headings-text/Ada_Zangemann-headings-text.es.sla: build/es/images/illustrations build/es/Ada_Zangemann.dbk
	mkdir -p build/es/headings-text
	if [ ! -h build/es/headings-text/images ]; then ln -s ../images build/es/headings-text/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/es/Ada_Zangemann.dbk --stringparam profile.condition headings-text xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1


# Build version with no conditional content (for debugging)
build/en/headings-none/Ada_Zangemann-headings-none.en.sla: build/en/images/illustrations build/en/Ada_Zangemann.dbk
	mkdir -p build/en/headings-none
	if [ ! -h build/en/headings-none/images ]; then ln -s ../images build/en/headings-none/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.dbk --stringparam profile.condition ";" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/de/headings-none/Ada_Zangemann-headings-none.de.sla: build/de/images/illustrations build/de/Ada_Zangemann.dbk
	mkdir -p build/de/headings-none
	if [ ! -h build/de/headings-none/images ]; then ln -s ../images build/de/headings-none/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/de/Ada_Zangemann.dbk --stringparam profile.condition ";" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/es/headings-none/Ada_Zangemann-headings-none.es.sla: build/es/images/illustrations build/es/Ada_Zangemann.dbk
	mkdir -p build/es/headings-none
	if [ ! -h build/es/headings-none/images ]; then ln -s ../images build/es/headings-none/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/es/Ada_Zangemann.dbk --stringparam profile.condition ";" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1


# Link template files, for development
build/%/template-print.sla:
	if [ ! -h $@ ]; then ln -s ../../templates/template-print.sla $@; fi


# Build version with text headers
build/en/print-headings-text/Ada_Zangemann-en-print-headings-text.sla: build/en/images/illustrations build/en/Ada_Zangemann.dbk
	mkdir -p build/en/print-headings-text
	if [ ! -h build/en/print-headings-text/images ]; then ln -s ../images build/en/print-headings-text/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.dbk --stringparam profile.condition "headings-text" xsl/scribus.xsl templates/template-print.sla


# Format docbook file using xmllint
.PHONY: xmllint-format
xmllint-format: Ada_Zangemann.dbk
	mv Ada_Zangemann.dbk Ada_Zangemann.dbk.xsmllintbak
	xmllint --format Ada_Zangemann.dbk.xsmllintbak > Ada_Zangemann.dbk


# Remove build output
.PHONY: clean
clean:
	rm -r build/


# Validation commands (work in progress)
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
