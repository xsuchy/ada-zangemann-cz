<?xml version="1.0" encoding="utf-8"?>
<!-- exclude-result-prefixes setting to prevent namespaces to end up in output -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook" db:version="5.0"
                xmlns:az="https://git.fsfe.org/FSFE/ada-zangemann/"
                exclude-result-prefixes="db az">

  <!-- Generic approach is to correspond docbook-id attribute with xml:id and
       resolve any inline elements depending on input and output. It starts from
       the template and reads the DocBook file as an external file.
  -->

  <!-- Debugging tips:

       Insert text:
       <xsl:text>HERE</xsl:text>

       Insert value of variable:
       <xsl:value-of select="$matching-element"/>

       Output message via XSLT processor:
       <xsl:message>Message</xsl:message>
  -->


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
    <!-- Matches StoryText elements in a PAGEOBJECT for text (PTYPE=4) with a docbook-id Attribute -->
    <xsl:template match="/SCRIBUSUTF8NEW/DOCUMENT/PAGEOBJECT[@PTYPE='4' and PageItemAttributes/ItemAttribute[@Name='docbook-id']]/StoryText">

      <!-- Get docbook-id attribute set in Scribus -->
      <xsl:variable name="docbook-id" select="../PageItemAttributes/ItemAttribute[@Name='docbook-id']/@Value" />

      <!-- Get type of matching element -->
      <xsl:variable name="matching-element" select="local-name(document($docbook-contents-file)//*[@xml:id=$docbook-id])"/>

      <!-- Copy StoryText element -->
      <xsl:copy>

        <!-- TODO: insert font and size attributes from styles as defined in DocBook file -->

        <!-- Warning message if Scribus template contains character styles -->
        <xsl:if test="./ITEXT[1]/@*[not(local-name() = 'CH')]">
          <xsl:message>WARNING: In StoryText element with docbook-id='<xsl:value-of select="$docbook-id"/>': Found formatting settings on characters using the Story Editor. Processing will ignore these character settings in favor of the formatting applied to the Text Frame. These Text Properties can be accessed using F3 shortcut. Adjust the style using the Text Frame settings, not selecting text, but the text frame. Settings in the StoryEditor are ignored and overruled.</xsl:message>
        </xsl:if>

        <!-- Copy Text Frame properties, which might refer to a parent style -->
        <xsl:copy-of select="./DefaultStyle[1]"/>

        <!-- Different handling depending on matched element (section, title, subtitle, bridgehead) -->
        <xsl:choose>

          <!-- A DocBook section: load text from <para> and <literallayout> elements -->
          <xsl:when test="$matching-element='section'">

            <xsl:for-each select="document($docbook-contents-file)//db:section[@xml:id=$docbook-id]/*[local-name()='para' or local-name()='literallayout']">
              <xsl:apply-templates select="."/>

              <!-- Two para separators are needed inbetween paragraphs to insert two newlines to end the first paragraph and create an empty line between the paragraphs. -->
              <!-- FIXME: Prefer paragraph styles in favor of hard newlines. -->
              <xsl:if test="not(position() = last())">
                <para/>
                <para/>
              </xsl:if>
            </xsl:for-each>

          </xsl:when>

          <!-- An image modelled inside a mediaobject -->
          <!-- FIXME: consider removing this altogether -->
          <xsl:when test="$matching-element='mediaobject'">
            <xsl:message>WARNING: In StoryText element with docbook-id='<xsl:value-of select="$docbook-id"/>': Matches a mediaobject. Loading text from mediaobject is not supported.</xsl:message>
          </xsl:when>

          <!-- Default case, for title, subtitle, bridgehead -->
          <xsl:otherwise>
            <ITEXT>
              <xsl:attribute name="CH">
                <xsl:for-each select="document($docbook-contents-file)//*[@xml:id=$docbook-id][1]">
                  <xsl:choose>
                    <!-- Don't normalize space for literallayout element -->
                    <xsl:when test="$matching-element='literallayout'">
                      <xsl:value-of select="."/>
                    </xsl:when>
                    <!-- Normalize space in normal case -->
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(.)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:attribute>
            </ITEXT>
          </xsl:otherwise>

        </xsl:choose>

        <!-- Indicator of the end of the text -->
        <trail/>

      </xsl:copy>
    </xsl:template>

    <!-- Match PageObject of type image (PTYPE = 2) -->
    <xsl:template match="/SCRIBUSUTF8NEW/DOCUMENT/PAGEOBJECT[@PTYPE='2' and PageItemAttributes/ItemAttribute[@Name='docbook-id']]">

      <!-- Get docbook-id attribute set in Scribus -->
      <xsl:variable name="docbook-id" select="./PageItemAttributes/ItemAttribute[@Name='docbook-id']/@Value" />

      <!-- Find filename defined in imagedata object. Match first encountered element to handle most situations. -->
      <!-- FIXME: XPATH expression doesn't work if xml:id matches on the imagedata object -->
      <xsl:variable name="filename" select="document($docbook-contents-file)//*[@xml:id=$docbook-id]//*[local-name() = 'imagedata' and @fileref][1]/@fileref"/>

      <!-- FIXME: consider handling depending on matched element -->
      <xsl:copy>
        <!-- Set PFILE attribute based on matched filename -->
        <xsl:attribute name="PFILE"><xsl:value-of select="$filename"/></xsl:attribute>

        <!-- Copy other attributes and nodes -->
        <xsl:apply-templates select="@*[not(local-name() = 'PFILE')]|node()"/>
      </xsl:copy>
    </xsl:template>

    <!-- FIXME: idea to append or change font names instead of replacing the font entirely -->

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
          <!-- FIXME: doesn't handle case of trailing punctuation (.,;:!) -->
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
