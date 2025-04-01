<?xml version="1.0" encoding="utf-8"?>

<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: GPL-3.0-or-later
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:db="http://docbook.org/ns/docbook" db:version="5.0" xmlns:az="https://git.fsfe.org/FSFE/ada-zangemann/" xmlns:its="http://www.w3.org/2005/11/its" xmlns:itst="http://itstool.org/extensions/" its:version="2.0">

  <!-- XSLT 1.0 file to remove elements and attributes of certain namespaces -->

  <!-- Identity template to reproduce content -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove nodes and attributes from specific namespaces -->
  <xsl:template match="@its:*|its:*" />
  <xsl:template match="@itst:*|itst:*" />
  <xsl:template match="@az:*|az:*" />
</xsl:stylesheet>
