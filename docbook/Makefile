# SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

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
