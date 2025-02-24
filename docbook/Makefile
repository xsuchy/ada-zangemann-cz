# SPDX-FileCopyrightText: 2024-2025 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0


# Translation file
po/Ada_Zangemann.pot: Ada_Zangemann.dbk
	itstool -o $@ Ada_Zangemann.dbk


# Update .po files when .pot strings get updated
po/en.po: po/Ada_Zangemann.pot
	if [ ! -e 'po/en.po' ]; then cp po/Ada_Zangemann.pot po/en.po; fi
	msgmerge --no-wrap --update po/en.po po/Ada_Zangemann.pot

po/de.po: po/Ada_Zangemann.pot
	if [ ! -e 'po/de.po' ]; then cp po/Ada_Zangemann.pot po/de.po; fi
	msgmerge --no-wrap --update po/de.po po/Ada_Zangemann.pot

po/es.po: po/Ada_Zangemann.pot
	if [ ! -e 'po/es.po' ]; then cp po/Ada_Zangemann.pot po/es.po; fi
	msgmerge --no-wrap --update po/es.po po/Ada_Zangemann.pot


# Generate message strings for further processing
build/en/en.mo: po/en.po
	mkdir -p build/en
	msgfmt -o build/en/en.mo po/en.po

build/de/de.mo: po/de.po
	mkdir -p build/de
	msgfmt -o build/de/de.mo po/de.po

build/es/es.mo: po/es.po
	mkdir -p build/es
	msgfmt -o build/es/es.mo po/es.po


# Link images
build/%/images/illustrations:
	makefile_helpers/./imagedir.sh $(shell echo ${@} | sed -n 's/.*build\/\(.*\)\/images.*/\1/p')


# Create docbook files
build/en/Ada_Zangemann.en.dbk: Ada_Zangemann.dbk build/en/en.mo
	itstool -m build/en/en.mo -o build/en/ Ada_Zangemann.dbk
	mv build/en/Ada_Zangemann.dbk build/en/Ada_Zangemann.en.dbk

build/de/Ada_Zangemann.de.dbk: Ada_Zangemann.dbk build/de/de.mo
	itstool -m build/de/de.mo -o build/de/ Ada_Zangemann.dbk
	mv build/de/Ada_Zangemann.dbk build/de/Ada_Zangemann.de.dbk

build/es/Ada_Zangemann.es.dbk: Ada_Zangemann.dbk build/es/es.mo
	itstool -m build/es/es.mo -o build/es/ Ada_Zangemann.dbk
	mv build/es/Ada_Zangemann.dbk build/es/Ada_Zangemann.es.dbk


# Create 'pure' docbook files without custom elements
build/en/Ada_Zangemann-pure.en.dbk: build/en/Ada_Zangemann.en.dbk xsl/clean-docbook.xsl
	xsltproc -o $@ xsl/clean-docbook.xsl build/en/Ada_Zangemann.en.dbk

build/de/Ada_Zangemann-pure.de.dbk: build/de/Ada_Zangemann.de.dbk xsl/clean-docbook.xsl
	xsltproc -o $@ xsl/clean-docbook.xsl build/de/Ada_Zangemann.de.dbk

build/es/Ada_Zangemann-pure.es.dbk: build/es/Ada_Zangemann.es.dbk xsl/clean-docbook.xsl
	xsltproc -o $@ xsl/clean-docbook.xsl build/es/Ada_Zangemann.es.dbk


# HTML output using standard docbook processing
# TODO: use lower resolution images
build/en/Ada_Zangemann.en.html: build/en/Ada_Zangemann-pure.en.dbk
	xsltproc -o build/en/Ada_Zangemann.en.html /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl build/en/Ada_Zangemann-pure.en.dbk

build/de/Ada_Zangemann.de.html: build/de/Ada_Zangemann-pure.de.dbk
	xsltproc -o build/de/Ada_Zangemann.de.html /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl build/de/Ada_Zangemann-pure.de.dbk

build/es/Ada_Zangemann.es.html: build/es/Ada_Zangemann-pure.es.dbk
	xsltproc -o build/es/Ada_Zangemann.es.html /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl build/es/Ada_Zangemann-pure.es.dbk


# Build version with all images (for debugging)
build/en/print-all/Ada_Zangemann-print-all.en.sla: build/en/images/illustrations build/en/Ada_Zangemann.en.dbk
	mkdir -p build/en/print-all
	if [ ! -h build/en/print-all/images ]; then ln -s ../images build/en/print-all/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.en.dbk xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/de/print-all/Ada_Zangemann-print-all.de.sla: build/de/images/illustrations build/de/Ada_Zangemann.de.dbk
	mkdir -p build/de/print-all
	if [ ! -h build/de/print-all/images ]; then ln -s ../images build/de/print-all/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/de/Ada_Zangemann.de.dbk xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/es/print-all/Ada_Zangemann-print-all.es.sla: build/es/images/illustrations build/es/Ada_Zangemann.es.dbk
	mkdir -p build/es/print-all
	if [ ! -h build/es/print-all/images ]; then ln -s ../images build/es/print-all/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/es/Ada_Zangemann.es.dbk xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1


# Build version with image headers
build/en/headings-img/Ada_Zangemann-headings-img.en.sla: build/en/images/illustrations build/en/Ada_Zangemann.en.dbk
	mkdir -p build/en/headings-img
	if [ ! -h build/en/headings-img/images ]; then ln -s ../images build/en/headings-img/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.en.dbk --stringparam profile.condition headings-img xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/de/headings-img/Ada_Zangemann-headings-img.de.sla: build/de/images/illustrations build/de/Ada_Zangemann.de.dbk
	mkdir -p build/de/headings-img
	if [ ! -h build/de/headings-img/images ]; then ln -s ../images build/de/headings-img/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/de/Ada_Zangemann.de.dbk --stringparam profile.condition headings-img xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/es/headings-img/Ada_Zangemann-headings-img.es.sla: build/es/images/illustrations build/es/Ada_Zangemann.es.dbk
	mkdir -p build/es/headings-img
	if [ ! -h build/es/headings-img/images ]; then ln -s ../images build/es/headings-img/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/es/Ada_Zangemann.es.dbk --stringparam profile.condition headings-img xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1


# Build version with text headers
build/en/headings-text/Ada_Zangemann-headings-text.en.sla: build/en/images/illustrations build/en/Ada_Zangemann.en.dbk
	mkdir -p build/en/headings-text
	if [ ! -h build/en/headings-text/images ]; then ln -s ../images build/en/headings-text/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.en.dbk --stringparam profile.condition headings-text xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/de/headings-text/Ada_Zangemann-headings-text.de.sla: build/de/images/illustrations build/de/Ada_Zangemann.de.dbk
	mkdir -p build/de/headings-text
	if [ ! -h build/de/headings-text/images ]; then ln -s ../images build/de/headings-text/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/de/Ada_Zangemann.de.dbk --stringparam profile.condition headings-text xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/es/headings-text/Ada_Zangemann-headings-text.es.sla: build/es/images/illustrations build/es/Ada_Zangemann.es.dbk
	mkdir -p build/es/headings-text
	if [ ! -h build/es/headings-text/images ]; then ln -s ../images build/es/headings-text/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/es/Ada_Zangemann.es.dbk --stringparam profile.condition headings-text xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1


# Build version with no conditional content (for debugging)
build/en/headings-none/Ada_Zangemann-headings-none.en.sla: build/en/images/illustrations build/en/Ada_Zangemann.en.dbk
	mkdir -p build/en/headings-none
	if [ ! -h build/en/headings-none/images ]; then ln -s ../images build/en/headings-none/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.en.dbk --stringparam profile.condition ";" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/de/headings-none/Ada_Zangemann-headings-none.de.sla: build/de/images/illustrations build/de/Ada_Zangemann.de.dbk
	mkdir -p build/de/headings-none
	if [ ! -h build/de/headings-none/images ]; then ln -s ../images build/de/headings-none/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/de/Ada_Zangemann.de.dbk --stringparam profile.condition ";" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1

build/es/headings-none/Ada_Zangemann-headings-none.es.sla: build/es/images/illustrations build/es/Ada_Zangemann.es.dbk
	mkdir -p build/es/headings-none
	if [ ! -h build/es/headings-none/images ]; then ln -s ../images build/es/headings-none/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/es/Ada_Zangemann.es.dbk --stringparam profile.condition ";" xsl/scribus.xsl templates/template-print.sla > $@.log 2>&1


# Link template files, for development
build/%/template-print.sla:
	if [ ! -h $@ ]; then ln -s ../../templates/template-print.sla $@; fi


# Build version with text headers
build/en/print-headings-text/Ada_Zangemann-en-print-headings-text.sla: build/en/images/illustrations build/en/Ada_Zangemann.en.dbk
	mkdir -p build/en/print-headings-text
	if [ ! -h build/en/print-headings-text/images ]; then ln -s ../images build/en/print-headings-text/images; fi
	xsltproc -o $@ --verbose --stringparam docbook-contents-file ../build/en/Ada_Zangemann.en.dbk --stringparam profile.condition "headings-text" xsl/scribus.xsl templates/template-print.sla


.PHONY: xmllint-format
xmllint-format: Ada_Zangemann.dbk
	mv Ada_Zangemann.dbk Ada_Zangemann.dbk.xsmllintbak
	xmllint --format Ada_Zangemann.dbk.xsmllintbak > Ada_Zangemann.dbk


.PHONY: clean
clean:
	rm -r build/


# Older commands, to be replaced


# Requires dblatex package in Debian
Ada_Zangemann-en-dblatex.pdf: Ada_Zangemann-en.dbk
	dblatex -o Ada_Zangemann-en-dblatex.pdf Ada_Zangemann-en.dbk

# Requires dbtoepub package in Debian
Ada_Zangemann-en-dbtoepub.epub: Ada_Zangemann-en-pure.dbk
	dbtoepub -o Ada_Zangemann-en-dbtoepub.epub Ada_Zangemann-en-pure.dbk


# TODO: consider moving to an output folder, while keeping links to images
Ada_Zangemann-de-print-all.sla: output/de/Ada_Zangemann.dbk templates/template-print.sla
	mkdir -p output/de/
	xsltproc -o Ada_Zangemann-de-print-all.sla --verbose --stringparam docbook-contents-file "../output/de/Ada_Zangemann.dbk" xsl/scribus.xsl templates/template-print.sla

Ada_Zangemann-es-print-all.sla: output/es/Ada_Zangemann.dbk templates/template-print.sla
	mkdir -p output/es/
	xsltproc -o Ada_Zangemann-es-print-all.sla --verbose --stringparam docbook-contents-file "../output/es/Ada_Zangemann.dbk" xsl/scribus.xsl templates/template-print.sla


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


build/intermediates/en/Ada_Zangemann-print-all.sla: language-package-en-img-heading build/generated/en/Ada_Zangemann.dbk xsl/template-print.sla
	mkdir -p build/intermediates/en
	xsltproc -o build/intermediates/en/Ada_Zangemann-print-all.sla --verbose --stringparam docbook-contents-file "../build/generated/en/Ada_Zangemann.dbk" xsl/scribus.xsl xsl/template-print.sla

build/intermediates/es/Ada_Zangemann-print-all.sla: language-package-es-img-heading build/generated/es/Ada_Zangemann.dbk xsl/template-print.sla
	mkdir -p build/intermediates/es
	xsltproc -o build/intermediates/es/Ada_Zangemann-print-all.sla --verbose --stringparam docbook-contents-file "../build/generated/es/Ada_Zangemann.dbk" xsl/scribus.xsl xsl/template-print.sla

Ada_Zangemann-de-print-all.sla: output/de/Ada_Zangemann.dbk xsl/template-print.sla
	mkdir -p output/de/
	xsltproc -o Ada_Zangemann-de-print-all.sla --verbose --stringparam docbook-contents-file "../output/de/Ada_Zangemann.dbk" xsl/scribus.xsl xsl/template-print.sla
