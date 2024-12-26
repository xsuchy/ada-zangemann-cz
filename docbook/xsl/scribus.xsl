<?xml version="1.0" encoding="utf-8"?>
<!-- This setup starts from the templates and reads docbook file as an external file -->
<!-- exclude-result-prefixes setting to prevent namespaces to end up in output -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook" db:version="5.0"
                xmlns:az="https://git.fsfe.org/FSFE/ada-zangemann/"
                exclude-result-prefixes="db az">

  <!-- Idea to correspond docbook-id attribute with xml:id and resolve any inline elements depending on input and output -->

  <!-- Input parameter for the DocBook source file that should be used to insert data into Scribus -->
  <xsl:param name="docbook-contents-file"/>

    <!-- Output format for Scribus is XML -->
    <xsl:output method="xml" indent="no"/>

    <!-- Identity template to copy all contents of the Scribus template. Only for elements without namespace (Scribus), to prevent handling DocBook elements. -->
    <xsl:template match="@*|node()[namespace-uri()='']">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>

    <!-- TODO: handle images, headers and title page -->

    <!-- Template to handle StoryText objects by recreating the content -->
    <!-- Matches StoryText elements in a PAGEOBJECT with a docbook-id Attribute -->
    <xsl:template match="/SCRIBUSUTF8NEW/DOCUMENT/PAGEOBJECT[PageItemAttributes/ItemAttribute[@Name='docbook-id']]/StoryText">
      <!-- Get docbook-id attribute set in Scribus -->
      <xsl:variable name="docbook-id" select="../PageItemAttributes/ItemAttribute[@Name='docbook-id']/@Value" />

      <!-- Copy StoryText element -->
      <xsl:copy>

        <!-- Optional debugging output -->
        <!-- <xsl:text>HERE</xsl:text> -->
        <!-- <xsl:value-of select="$docbook-id"/> -->

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
          <xsl:apply-templates select="."/>

          <!-- Two para separators are needed to insert two newlines to end the first paragraph and create an empty line between the paragraphs. -->
          <!-- TODO: 2024-12-03 The <para/> nodes after the last ITEXT is not necessary and should be removed. This would trigger unnecessary warnings in Scribus for text outside the frame.  -->
          <para/>
          <para/>
        </xsl:for-each>

        <xsl:for-each select="document($docbook-contents-file)//db:section[@xml:id=$docbook-id]/db:literallayout">
          <!-- FIXME: consider replacing newlines by <para/> separators -->
          <!-- Further processing using other templates -->
          <xsl:apply-templates select="."/>

          <!-- Two <para/> separators are needed to insert two newlines to end the first paragraph and create an empty line between the paragraphs. -->
          <!-- TODO: 2024-12-03 The <para/> nodes after the last ITEXT is not necessary and should be removed. This would trigger unnecessary warnings in Scribus for text outside the frame.  -->
          <para/>
          <para/>
        </xsl:for-each>

        <!-- Indicator of the end of the text -->
        <trail/>
      </xsl:copy>
    </xsl:template>

    <!-- TODO: unify emphasis handling between db:para and db:literallayout elements -->
    <xsl:template match="//db:literallayout/db:emphasis">
      <!-- Default emphasis -->
      <!-- FIXME: Doesn't support nesting of emphasis or other nested elements -->
      <!-- TODO: Heebo italic font not available or not installed -->
      <ITEXT>
        <xsl:attribute name="FONT">Roboto Italic</xsl:attribute>
        <xsl:attribute name="CH">
          <xsl:value-of select="./text()"/>
        </xsl:attribute>
      </ITEXT>
    </xsl:template>

    <xsl:template match="//db:literallayout/db:emphasis[@role='bold']|db:emphasis[@role='strong']">
      <!-- FIXME: Doesn't support nesting of emphasis or other nested elements -->
      <ITEXT>
        <xsl:attribute name="FONT">Heebo Bold</xsl:attribute>
        <xsl:attribute name="CH">
          <xsl:value-of select="./text()"/>
        </xsl:attribute>
      </ITEXT>
    </xsl:template>

    <xsl:template match="//db:literallayout/text()">
      <ITEXT>
        <xsl:attribute name="CH">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </ITEXT>
    </xsl:template>

    <xsl:template match="//db:literallayout/*[not(self::db:emphasis)]">
      <!-- NOTE: links and other elements will result in multiple ITEXT nodes -->
      <ITEXT>
        <xsl:attribute name="CH">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </ITEXT>
    </xsl:template>

    <!-- Further processing of para nodes -->
    <xsl:template match="//db:para/*[not(self::db:emphasis)]">
      <!-- NOTE: links and other elements will result in multiple ITEXT nodes -->
      <ITEXT>
        <xsl:attribute name="CH">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
      </ITEXT>
    </xsl:template>

    <!-- TODO: make specific for roles -->
    <xsl:template match="//db:para/db:emphasis">
      <!-- Default emphasis -->
      <!-- FIXME: Doesn't support nesting of emphasis or other nested elements -->
      <!-- TODO: Heebo italic font not available or not installed -->
      <ITEXT>
        <xsl:attribute name="FONT">Roboto Italic</xsl:attribute>
        <xsl:attribute name="CH">
          <xsl:value-of select="normalize-space(./text())"/>
        </xsl:attribute>
      </ITEXT>
    </xsl:template>

    <xsl:template match="//db:para/db:emphasis[@role='bold']|db:emphasis[@role='strong']">
      <!-- FIXME: Doesn't support nesting of emphasis or other nested elements -->
      <ITEXT>
        <xsl:attribute name="FONT">Heebo Bold</xsl:attribute>
        <xsl:attribute name="CH">
          <xsl:value-of select="normalize-space(./text())"/>
        </xsl:attribute>
      </ITEXT>
    </xsl:template>

    <!-- Handle first text section -->
    <xsl:template match="//db:para/text()[1]">
      <ITEXT>
        <xsl:attribute name="CH">
          <xsl:choose>
            <xsl:when test="../@az:dropcap='true'">

              <!-- Strip the first character if a dropcap image is used -->
              <!-- FIXME: doesn't handle an emphasis that starts at the beginning of the line. Alternative could be to process dropcaps edge case as a final step -->
              <xsl:value-of select="substring(normalize-space(), 2)"/>
              <xsl:if test="following-sibling::node()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space()"/>
            </xsl:otherwise>
            </xsl:choose>
            <!-- Append a trailing space if other content follows -->
            <xsl:if test="following-sibling::node()">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:attribute>
      </ITEXT>
    </xsl:template>

    <!-- Handle generic text, not influenced by dropcaps -->
    <xsl:template match="//db:para/text()[position() > 1]">
      <ITEXT>
        <xsl:attribute name="CH">

          <!-- Normalize space in elements inside paragraph. Insert preseding of trailing space if other nodes exist, like emphasized text or a link. -->
          <!-- NOTE: this forces a spect around emphasized text or link, which could be good -->
          <xsl:if test="preceding-sibling::node()">
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space()"/>
          <xsl:if test="following-sibling::node()">
            <xsl:text> </xsl:text>
          </xsl:if>

        </xsl:attribute>
      </ITEXT>
    </xsl:template>

</xsl:stylesheet>
