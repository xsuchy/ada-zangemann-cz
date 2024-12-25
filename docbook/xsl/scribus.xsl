<?xml version="1.0" encoding="utf-8"?>
<!-- This setup starts from the templates and reads docbook file as an external file -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:db="http://docbook.org/ns/docbook" db:version="5.0" xmlns:az="https://git.fsfe.org/FSFE/ada-zangemann/">

  <!-- Idea to correspond docbook-id attribute with xml:id and resolve any inline elements depending on input and output -->

  <!-- Input parameter for the DocBook source file that should be used to insert data into Scribus -->
  <xsl:param name="docbook-contents-file"/>

    <!-- Output format for Scribus is XML -->
    <!-- <xsl:output method="xml" indent="no"/> -->
    <xsl:output method="xml" indent="yes"/>

    <!-- Identity template to copy all contents of the Scribus template -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- TODO: handle images, headers and title page -->

    <!-- Template to handle StoryText objects by recreating the content -->
    <!-- Matches StoryText elements in a PAGEOBJECT with a docbook-id Attribute -->
    <xsl:template match="/SCRIBUSUTF8NEW/DOCUMENT/PAGEOBJECT[PageItemAttributes/ItemAttribute[@Name='docbook-id']]/StoryText">
      <xsl:variable name="anname" select="../@ANNAME" />
      <xsl:variable name="docbook-id" select="../PageItemAttributes/ItemAttribute[@Name='docbook-id']/@Value" />
      <xsl:copy>
        <!-- Optional debugging output -->
        <!-- <xsl:text>HERE</xsl:text> -->
        <!-- <xsl:value-of select="../@ANNAME"/> -->
        <!-- <xsl:value-of select="$anname"/> -->
        <!-- <xsl:value-of select="$docbook-id"/> -->
        <!-- <xsl:value-of select="document($docbook-contents-file)/db:book/db:chapter/db:section[@xml:id=sec-p06]"/> -->

        <!-- Copy original content by applying the built-in template -->
        <!-- <xsl:apply-templates select="@*|node()" /> -->

        <!-- Copy first DefaultStyle node by applying the built-in template. Copy it because it might contain settings. -->
        <xsl:apply-templates select="./DefaultStyle[1]"/>

        <!-- Handle all <para> and <literallayout> nodes in the section where the xml:id matches the docbook-id attribute of the text frame -->
        <!-- NOTE: idea to match all elements based on the XML-id, not just para and literallayout, to allow for more flexiblity in the template -->
        <!-- <xsl:for-each select="document($docbook-contents-file)//*[@xml:id=$anname]/*[local-name()='para' or local-name()='literallayout']"> -->
        <!-- Previous selection which matched both para and literallayout elements: -->
        <!-- <xsl:for-each select="document($docbook-contents-file)//db:section[@xml:id=$docbook-id]/*[local-name()='para' or local-name()='literallayout']"> -->
        <xsl:for-each select="document($docbook-contents-file)//db:section[@xml:id=$docbook-id]/db:para">
          <ITEXT>
          <!-- NOTE: normalize-space removes replaces extended whitespace and thus removes line breaks too. A literallayout structure requires special handling -->
          <xsl:attribute name="CH">
            <!-- TODO: make sure to call template to process emphasis marks, similar as in literallayout -->
            <xsl:choose>
              <xsl:when test="@az:dropcap='true'">
                <!-- Strip the first character if a dropcap image is used -->
                <xsl:value-of select="substring(normalize-space(.), 2)"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- <xsl:apply-templates select="."/> -->
                <xsl:value-of select="normalize-space(.)"/>
                <!-- TODO: find best way for additional processing on inserted content -->
                <!-- <xsl:apply-templates select="emphasis"/> -->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          </ITEXT>
          <!-- Two para separators are needed to insert two newlines to end the first paragraph and create an empty line between the paragraphs. -->
          <!-- TODO: 2024-12-03 The <para/> nodes after the last ITEXT is not necessary and should be removed. This would trigger unnecessary warnings in Scribus for text outside the frame.  -->
          <para/>
          <para/>
        </xsl:for-each>

        <xsl:for-each select="document($docbook-contents-file)//db:section[@xml:id=$docbook-id]/db:literallayout">
          <!-- FIXME: consider replacing newlines by <para/> separators -->
          <ITEXT>
            <!-- Further processing using other templates -->
            <xsl:apply-templates select="."/>
          </ITEXT>
          <!-- Two <para/> separators are needed to insert two newlines to end the first paragraph and create an empty line between the paragraphs. -->
          <!-- TODO: 2024-12-03 The <para/> nodes after the last ITEXT is not necessary and should be removed. This would trigger unnecessary warnings in Scribus for text outside the frame.  -->
          <para/>
          <para/>
        </xsl:for-each>

        <!-- Indicator of the end of the text -->
        <trail/>

        <!-- TODO: additional processing: 2) copy text into ITEXT nodes, 3) deal with emphasis remarks -->
      </xsl:copy>
    </xsl:template>

    <xsl:template match="db:emphasis[not(@role)]">
      <!-- Default emphasis -->
      <!-- FIXME: could be combined with the explicit rule -->
      <ITEXT><!-- TODO: change element name -->
        <xsl:attribute name="FONT">Heebo Italic</xsl:attribute>
        <xsl:attribute name="CH"><xsl:value-of select="./text()"/></xsl:attribute>
      </ITEXT>
    </xsl:template>

    <xsl:template match="db:emphasis[@role='italic']">
      <ITEXT><!-- TODO: change element name -->
        <xsl:attribute name="FONT">Heebo Italic</xsl:attribute>
        <xsl:attribute name="CH"><xsl:value-of select="./text()"/></xsl:attribute>
      </ITEXT>
    </xsl:template>

    <xsl:template match="db:emphasis[@role='bold']|db:emphasis[@role='strong']">
      <ITEXT><!-- TODO: change element name -->
        <xsl:attribute name="FONT">Heebo Bold</xsl:attribute>
        <xsl:attribute name="CH"><xsl:value-of select="./text()"/></xsl:attribute>
      </ITEXT>
    </xsl:template>

    <xsl:template match="//db:literallayout/text()">
      <ITEXT>
        <xsl:attribute name="CH"><xsl:value-of select="."/></xsl:attribute>
      </ITEXT>
    </xsl:template>

    <xsl:template match="//db:literallayout/*[not(self::db:emphasis)]">
      <!-- NOTE: links and other elements will result in multiple ITEXT nodes -->
      <ITEXT>
        <xsl:attribute name="CH"><xsl:value-of select="."/></xsl:attribute>
      </ITEXT>
    </xsl:template>


</xsl:stylesheet>
