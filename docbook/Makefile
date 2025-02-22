# SPDX-FileCopyrightText: 2024-2025 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

build/%/images/illustrations:
	makefile_helpers/./imagedir.sh $(shell echo ${@} | sed -n 's/.*build\/\(.*\)\/images.*/\1/p')

# TODO: make specific for German edition
output/de/Ada_Zangemann.html: Ada_Zangemann-en-pure.dbk
	xsltproc -o Ada_Zangemann-en.html /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl Ada_Zangemann-en-pure.dbk

Ada_Zangemann-en.html: Ada_Zangemann-en-pure.dbk
	xsltproc -o Ada_Zangemann-en.html /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl Ada_Zangemann-en-pure.dbk

Ada_Zangemann-en-print-all.sla: Ada_Zangemann-en.dbk xsl/scribus.xsl xsl/template-print.sla
	xsltproc -o Ada_Zangemann-en-print-all.sla --verbose --stringparam docbook-contents-file "../Ada_Zangemann-en.dbk" xsl/scribus.xsl xsl/template-print.sla

Ada_Zangemann-en-print-img.sla: Ada_Zangemann-en.dbk xsl/scribus.xsl xsl/template-print.sla
	xsltproc -o Ada_Zangemann-en-print-img.sla --verbose --stringparam docbook-contents-file "../Ada_Zangemann-en.dbk" --stringparam profile.condition "headings-img" xsl/scribus.xsl xsl/template-print.sla

Ada_Zangemann-en-print-text.sla: Ada_Zangemann-en.dbk xsl/scribus.xsl xsl/template-print.sla
	xsltproc -o Ada_Zangemann-en-print-text.sla --verbose --stringparam docbook-contents-file "../Ada_Zangemann-en.dbk" --stringparam profile.condition "headings-text" xsl/scribus.xsl xsl/template-print.sla

Ada_Zangemann-en-print-none.sla: Ada_Zangemann-en.dbk xsl/scribus.xsl xsl/template-print.sla
	xsltproc -o Ada_Zangemann-en-print-none.sla --verbose --stringparam docbook-contents-file "../Ada_Zangemann-en.dbk" --stringparam profile.condition ";" xsl/scribus.xsl xsl/template-print.sla

Ada_Zangemann-en-pure.dbk: Ada_Zangemann-en.dbk xsl/clean-docbook.xsl
	xsltproc -o Ada_Zangemann-en-pure.dbk xsl/clean-docbook.xsl Ada_Zangemann-en.dbk

# Requires dblatex package in Debian
Ada_Zangemann-en-dblatex.pdf: Ada_Zangemann-en.dbk
	dblatex -o Ada_Zangemann-en-dblatex.pdf Ada_Zangemann-en.dbk

# Requires dbtoepub package in Debian
Ada_Zangemann-en-dbtoepub.epub: Ada_Zangemann-en-pure.dbk
	dbtoepub -o Ada_Zangemann-en-dbtoepub.epub Ada_Zangemann-en-pure.dbk

# Translations

# Translation file
po/Ada_Zangemann.pot: Ada_Zangemann-en.dbk
	itstool -o $@ Ada_Zangemann-en.dbk

# Update .po files when .pot strings get updated
po/de.po: po/Ada_Zangemann.pot
	if [ ! -e 'po/de.po' ]; then cp po/Ada_Zangemann.pot po/de.po; fi
	msgmerge --no-wrap --update po/de.po po/Ada_Zangemann.pot

po/es.po: po/Ada_Zangemann.pot
	if [ ! -e 'po/es.po' ]; then cp po/Ada_Zangemann.pot po/es.po; fi
	msgmerge --no-wrap --update po/es.po po/Ada_Zangemann.pot

po/en.po: po/Ada_Zangemann.pot
	if [ ! -e 'po/en.po' ]; then cp po/Ada_Zangemann.pot po/en.po; fi
	msgmerge --no-wrap --update po/en.po po/Ada_Zangemann.pot

# Generate message strings for further processing
# FIXME: perhaps the .mo file should end up in a temporary process location instead of in the /po folder
po/de.mo: po/de.po
	msgfmt -o po/de.mo po/de.po

po/es.mo: po/es.po
	msgfmt -o po/es.mo po/es.po

# Create translated DocBook file using itstool
# TODO: find proper output directory and ensure it exists without calling mkdir
output/de/Ada_Zangemann.dbk: po/de.mo
	mkdir -p output/de/
	itstool -m po/de.mo -o output/de/ Ada_Zangemann-en.dbk
	mv output/de/Ada_Zangemann-en.dbk output/de/Ada_Zangemann.dbk

output/es/Ada_Zangemann.dbk: po/es.mo
	mkdir -p output/es/
	itstool -m po/es.mo -o output/es/ Ada_Zangemann-en.dbk
	mv output/es/Ada_Zangemann-en.dbk output/es/Ada_Zangemann.dbk

# TODO: consider moving to an output folder, while keeping links to images
Ada_Zangemann-de-print-all.sla: output/de/Ada_Zangemann.dbk xsl/template-print.sla
	mkdir -p output/de/
	xsltproc -o Ada_Zangemann-de-print-all.sla --verbose --stringparam docbook-contents-file "../output/de/Ada_Zangemann.dbk" xsl/scribus.xsl xsl/template-print.sla

Ada_Zangemann-es-print-all.sla: output/es/Ada_Zangemann.dbk xsl/template-print.sla
	mkdir -p output/es/
	xsltproc -o Ada_Zangemann-es-print-all.sla --verbose --stringparam docbook-contents-file "../output/es/Ada_Zangemann.dbk" xsl/scribus.xsl xsl/template-print.sla

.PHONY: xmllint-format
xmllint-format: Ada_Zangemann-en.dbk
	mv Ada_Zangemann-en.dbk Ada_Zangemann-en.dbk.bak && xmllint --format Ada_Zangemann-en.dbk.bak > Ada_Zangemann-en.dbk

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

# TODO: replace other rules with these work-in-progress definitions:
build/generated/de/Ada_Zangemann.dbk: po/de.mo
	mkdir -p build/generated/de
	itstool -m po/de.mo -o build/generated/de/ Ada_Zangemann.dbk

build/generated/en/en.mo: po/en.po
	mkdir -p build/generated/en
	msgfmt -o build/generated/en/en.mo po/en.po

build/generated/es/es.mo: po/es.po
	mkdir -p build/generated/es
	msgfmt -o build/generated/es/es.mo po/es.po

build/generated/en/Ada_Zangemann.dbk: build/generated/en/en.mo
	mkdir -p build/generated/en
	itstool -m build/generated/en/en.mo -o build/generated/en/ Ada_Zangemann.dbk

build/generated/es/Ada_Zangemann.dbk: build/generated/es/es.mo
	mkdir -p build/generated/es
	itstool -m build/generated/es/es.mo -o build/generated/es/ Ada_Zangemann.dbk

# Link files from nested structure. Force to overwrite existing links.
# TODO: create helper script to apply language packs
.PHONY: language-package-en-img-heading
language-package-en-img-heading:
	mkdir -p build/intermediates/en
	cp -rsf ${PWD}/language-packs/base-ltr/* build/intermediates/en/
	cp -rsf ${PWD}/language-packs/en/* build/intermediates/en/

.PHONY: language-package-en-text-heading
language-package-en-text-heading:
	mkdir -p build/intermediates/en
	cp -rsf ${PWD}/language-packs/base-ltr/* build/intermediates/en/
	cp -rsf ${PWD}/language-packs/en/* build/intermediates/en/
	cp -rsf ${PWD}/language-packs/blank-ltr/* build/intermediates/en/

.PHONY: language-package-es-img-heading
language-package-es-img-heading:
	mkdir -p build/intermediates/es
	cp -rsf ${PWD}/language-packs/base-ltr/* build/intermediates/es/
	cp -rsf ${PWD}/language-packs/es/* build/intermediates/es/

build/intermediates/en/Ada_Zangemann-print-all.sla: language-package-en-img-heading build/generated/en/Ada_Zangemann.dbk xsl/template-print.sla
	mkdir -p build/intermediates/en
	xsltproc -o build/intermediates/en/Ada_Zangemann-print-all.sla --verbose --stringparam docbook-contents-file "../build/generated/en/Ada_Zangemann.dbk" xsl/scribus.xsl xsl/template-print.sla

build/intermediates/es/Ada_Zangemann-print-all.sla: language-package-es-img-heading build/generated/es/Ada_Zangemann.dbk xsl/template-print.sla
	mkdir -p build/intermediates/es
	xsltproc -o build/intermediates/es/Ada_Zangemann-print-all.sla --verbose --stringparam docbook-contents-file "../build/generated/es/Ada_Zangemann.dbk" xsl/scribus.xsl xsl/template-print.sla

Ada_Zangemann-de-print-all.sla: output/de/Ada_Zangemann.dbk xsl/template-print.sla
	mkdir -p output/de/
	xsltproc -o Ada_Zangemann-de-print-all.sla --verbose --stringparam docbook-contents-file "../output/de/Ada_Zangemann.dbk" xsl/scribus.xsl xsl/template-print.sla

.PHONY: clean
clean:
	rm -r build/intermediates
