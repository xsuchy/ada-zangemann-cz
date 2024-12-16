# SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

po/Ada_Zangemann.pot: Ada_Zangemann-en.dbk
	itstool -o $@ Ada_Zangemann-en.dbk

Ada_Zangemann-en.html: Ada_Zangemann-en.dbk
	xsltproc -o Ada_Zangemann-en.html /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl Ada_Zangemann-en.dbk

Ada_Zangemann-en-print.sla: Ada_Zangemann-en.dbk xsl/scribus.xsl xsl/template-print.sla
	xsltproc -o Ada_Zangemann-en-print.sla --verbose --stringparam docbook-contents-file "../Ada_Zangemann-en.dbk" xsl/scribus.xsl xsl/template-print.sla

# Requires dblatex package in Debian
Ada_Zangemann-en-dblatex.pdf: Ada_Zangemann-en.dbk
	dblatex -o Ada_Zangemann-en-dblatex.pdf Ada_Zangemann-en.dbk

# Requires dbtoepub package in Debian
Ada_Zangemann-en-dbtoepub.epub: Ada_Zangemann-en.dbk
	dbtoepub -o Ada_Zangemann-en-dbtoepub.epub Ada_Zangemann-en.dbk

.PHONY: xmllint-format
xmllint-format: Ada_Zangemann-en.dbk
	mv Ada_Zangemann-en.dbk Ada_Zangemann-en.dbk.bak && xmllint --format Ada_Zangemann-en.dbk.bak > Ada_Zangemann-en.dbk
