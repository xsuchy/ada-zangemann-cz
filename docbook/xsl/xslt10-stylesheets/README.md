<!--
SPDX-FileCopyrightText: 2025 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# XSLT 1.0 stylesheets

This is a subset of the [XSLT 1.0 stylesheets for DocBook](https://github.com/docbook/xslt10-stylesheets) for use in processing.

## Notable changes

- In `xsl/profiling/profile.xsl` the `<xsl:template match="/">` is commented out as the profiling should not run on the main file (Scribus) but on the contents of a variable (DocBook).
