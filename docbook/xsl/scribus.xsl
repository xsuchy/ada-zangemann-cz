<?xml version="1.0" encoding="utf-8"?>
<!-- This setup starts from the templates and reads docbook file as an external file -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="cr"><xsl:text>
  </xsl:text></xsl:variable>

    <xsl:param name="docbook-contents-file"/>

    <xsl:output method="xml" indent="no"/>

    <!-- Identity template -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- TODO: handle acknowledgements and appendix from Docbook if modelled as such -->
    <xsl:template match="/SCRIBUSUTF8NEW/DOCUMENT/PAGEOBJECT[@ANNAME]/StoryText">
      <xsl:variable name="anname" select="../@ANNAME" />
      <xsl:copy>
        <!-- Optional debugging output -->
        <!-- <xsl:text>HERE</xsl:text> -->
        <!-- <xsl:value-of select="../@ANNAME"/> -->
        <!-- <xsl:value-of select="$anname"/> -->

        <!-- Copy first DefaultStyle node by applying the built-in template. Copy it because it might contain settings. -->
        <xsl:apply-templates select="./DefaultStyle[1]"/>

        <!-- Handle all <para> nodes in the chapter where the xml:id matches the ANNAME attribute of the text frame -->
        <xsl:for-each select="document($docbook-contents-file)/book/chapter[@xml:id=$anname]/para">
          <ITEXT>
          <!-- NOTE: normalize-space removes replaces extended whitespace and thus removes line breaks too. A literallayout structure requires special handling -->
          <xsl:attribute name="CH"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
          </ITEXT>
          <!-- TODO: 2024-12-03 The <para/> nodes after the last ITEXT is not necesary and should be removed -->
          <!-- TODO: 2024-12-03 Do we need 2 para nodes? -->
          <para/>
          <para/>
        </xsl:for-each>

        <!-- TODO: To be removed in the future when all content is added using XSLT -->
        <!-- Copy original content by applying the built-in template -->
        <!-- <xsl:apply-templates select="@*|node()" /> -->

        <!-- Indicator of the end of the text -->
        <trail/>

        <!-- TODO: additional processing: 2) copy text into ITEXT nodes, 3) deal with emphasis remarks -->
      </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
