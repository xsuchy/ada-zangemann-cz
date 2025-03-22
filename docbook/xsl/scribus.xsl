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

  <!-- Input parameter for profiling on conditions. Supports multiple conditions separated by semicolumns ';'. Lack of condition input will deactivate the checks. A single semicolumn can be provided to match no conditions. -->
  <!-- Related documentation from DocBook XSLT stylesheets: https://sagehill.net/docbookxsl/Profiling.html -->
  <!-- FIXME: Better match the DocBook XSLT behavior of conditions. 1) Current assumption is that a single condition is present in Scribus template. It should ideally support n:m conditions to better. XSLT 1.0 profiling templates can be used as a reference: https://github.com/docbook/xslt10-stylesheets/blob/master/xsl/profiling/profile-mode.xsl 2) Current behavior allows an empty string to match no conditoins, which is helpful for debugging, but might not be meeting expectations.-->
  <xsl:param name="profile.condition"/>

  <!-- Output format for Scribus is XML -->
  <xsl:output method="xml" indent="no"/>

  <!-- Identity template to copy all contents of the Scribus template. Only for elements without namespace (Scribus), to prevent handling DocBook elements. -->
  <xsl:template match="@*|node()[namespace-uri()='']">
    <xsl:variable name="db-condition" select="./PageItemAttributes/ItemAttribute[@Name='condition']/@Value"/>
    <!-- If a profile.condition is set and a condition is set on the Scribus object, then only copy if the condition matches. -->
    <xsl:if test="not($profile.condition) or not($db-condition) or contains(concat(';', $profile.condition, ';'), concat(';', $db-condition, ';'))">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <!-- Template to handle StoryText objects by recreating the content -->
  <!-- Matches StoryText elements in a PAGEOBJECT for text (PTYPE=4) with a docbook-id Attribute -->
  <xsl:template match="/SCRIBUSUTF8NEW/DOCUMENT/PAGEOBJECT[@PTYPE='4' and PageItemAttributes/ItemAttribute[@Name='docbook-id']]/StoryText">

    <!-- Get docbook-id attribute set in Scribus -->
    <xsl:variable name="docbook-id" select="../PageItemAttributes/ItemAttribute[@Name='docbook-id']/@Value"/>

    <xsl:call-template name="storytext">
      <xsl:with-param name="matching-content" select="document($docbook-contents-file)//*[@xml:id=$docbook-id]"/>
    </xsl:call-template>

  </xsl:template>


  <xsl:template name="storytext">
    <xsl:param name="matching-content"/>

    <!-- Get type of matching element -->
    <xsl:variable name="matching-element" select="local-name($matching-content)"/>

    <!-- Copy StoryText element -->
    <xsl:copy>

      <!-- TODO: insert font and size attributes from styles as defined in DocBook file -->

      <!-- Warning message if Scribus template contains character styles -->
      <xsl:if test="./ITEXT[1]/@*[not(local-name() = 'CH')]">
        <xsl:message>WARNING: Found formatting settings on characters using the Story Editor. Processing will ignore these character settings in favor of the formatting applied to the Text Frame. These Text Properties can be accessed using F3 shortcut. Adjust the style using the Text Frame settings, not selecting text, but the text frame. Settings in the StoryEditor are ignored and overruled.</xsl:message>
      </xsl:if>

      <!-- Copy Text Frame properties, which might refer to a parent style -->
      <xsl:copy-of select="./DefaultStyle[1]"/>

      <!-- Different handling depending on matched element (section, title, subtitle, bridgehead) -->
      <xsl:choose>

        <!-- A DocBook section: load text from <para> and <literallayout> elements -->
        <!-- FIXME: look if better ways exist to improve over a text-based match -->
        <xsl:when test="contains('|section|simplesect|sect1|sect2|sect3|sect4|sect5|', concat('|', $matching-element, '|'))">

          <xsl:for-each select="$matching-content/*[local-name()='para' or local-name()='literallayout']">
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
          <xsl:message>WARNING: Matches a mediaobject. Loading text from mediaobject is not supported.</xsl:message>
        </xsl:when>

        <!-- Default case, for title, subtitle, bridgehead -->
        <xsl:otherwise>
          <ITEXT>
            <xsl:attribute name="CH">
              <!-- <xsl:for-each select="document($docbook-contents-file)//*[@xml:id=$docbook-id][1]"> -->
              <xsl:for-each select="$matching-content[1]">
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

    <!-- Get condition set on PageObject -->
    <xsl:variable name="db-condition" select="./PageItemAttributes/ItemAttribute[@Name='condition']/@Value"/>

    <!-- If a profile.condition is set and a condition is set on the Scribus object, then only handle if the condition matches. -->
    <xsl:if test="not($profile.condition) or not($db-condition) or contains(concat(';', $profile.condition, ';'), concat(';', $db-condition, ';'))">

      <!-- Get docbook-id attribute set in Scribus -->
      <xsl:variable name="docbook-id" select="./PageItemAttributes/ItemAttribute[@Name='docbook-id']/@Value"/>

      <xsl:variable name="matching-content" select="document($docbook-contents-file)//*[@xml:id=$docbook-id]"/>

      <!-- Get type of matching element -->
      <xsl:variable name="matching-element" select="local-name($matching-content)"/>

      <xsl:choose>
        <!-- Handle dropcap images for paragraph elements -->
        <xsl:when test="$matching-element='para'">

          <!-- Get az:dropcapfileref attribute -->
          <xsl:variable name="filename" select="document($docbook-contents-file)//*[local-name() = 'para' and @xml:id=$docbook-id]/@az:dropcapfileref"/>

          <!-- Get resolution in percentage. Assume LOCALSCY is equal to LOCALSCX. Typically '0.16' for capitals. -->
          <xsl:variable name="localsc-docbook" select="document($docbook-contents-file)//*[local-name() = 'para' and @xml:id=$docbook-id]/@az:dropcaplocalsc"/>
          <xsl:variable name="localsc">
            <xsl:choose>
              <xsl:when test="not($localsc-docbook)">
                <xsl:value-of select="./@LOCALSCX"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$localsc-docbook"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <!-- Get dimensions in pt, which is number of pixels divided by 6.25 for a resolution of 0.16 -->
          <xsl:variable name="width-docbook" select="document($docbook-contents-file)//*[local-name() = 'para' and @xml:id=$docbook-id]/@az:dropcapwidthpt"/>
          <xsl:variable name="width">
            <xsl:choose>
              <xsl:when test="not($width-docbook)">
                <xsl:value-of select="./@WIDTH"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$width-docbook"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="height-docbook" select="document($docbook-contents-file)//*[local-name() = 'para' and @xml:id=$docbook-id]/@az:dropcapheightpt"/>
          <xsl:variable name="height">
            <xsl:choose>
              <xsl:when test="not($height-docbook)">
                <xsl:value-of select="./@HEIGHT"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$height-docbook"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <!-- Construct path string to prevent text over capital -->
          <xsl:variable name="path">
            <!-- path="M0 0 L40.1537 0 L40.1537 50.72 L0 50.72 L0 0 Z" -->
            <xsl:text>M0 0 L</xsl:text>
            <xsl:value-of select="$width"/>
            <xsl:text> 0 L</xsl:text>
            <xsl:value-of select="$width"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$height"/>
            <xsl:text> L0 </xsl:text>
            <xsl:value-of select="$height"/>
            <xsl:text> L0 0 Z</xsl:text>
          </xsl:variable>

          <!-- Construct PAGEOBJECT with adjusted properties -->
          <xsl:copy>
            <!-- Set PFILE attribute based on matched filename -->
            <xsl:attribute name="PFILE">
              <xsl:value-of select="$filename"/>
            </xsl:attribute>

            <xsl:attribute name="LOCALSCX">
              <xsl:value-of select="$localsc"/>
            </xsl:attribute>

            <xsl:attribute name="LOCALSCY">
              <xsl:value-of select="$localsc"/>
            </xsl:attribute>

            <xsl:attribute name="WIDTH">
              <xsl:value-of select="$width"/>
            </xsl:attribute>

            <xsl:attribute name="HEIGHT">
              <xsl:value-of select="$height"/>
            </xsl:attribute>

            <xsl:attribute name="path">
              <xsl:value-of select="$path"/>
            </xsl:attribute>

            <xsl:attribute name="copath">
              <xsl:value-of select="$path"/>
            </xsl:attribute>

            <!-- Copy other attributes and nodes.. -->
            <xsl:apply-templates select="@*[not(local-name() = 'PFILE' or local-name() = 'path' or local-name() = 'copath' or local-name() = 'LOCALSCX' or local-name() = 'LOCALSCY' or local-name() = 'WIDTH' or local-name() = 'HEIGHT')]|node()"/>
            <!-- TODO: consider skipping explicit PRFILE profile as well -->
          </xsl:copy>

        </xsl:when>
        <xsl:otherwise>

          <!-- Find filename defined in imagedata object. Match first encountered element to handle most situations. -->
          <!-- TODO: check conditions on surrounding imageobject to handle single-pass profiling of images -->
          <!-- FIXME: XPATH expression doesn't work if xml:id matches on the imagedata object -->
          <xsl:variable name="filename" select="$matching-content//*[local-name() = 'imagedata' and @fileref][1]/@fileref"/>

          <!-- FIXME: reduce duplication -->
          <xsl:copy>
            <!-- Set PFILE attribute based on matched filename -->
            <xsl:attribute name="PFILE">
              <xsl:value-of select="$filename"/>
            </xsl:attribute>
            <!-- Copy other attributes and nodes -->
            <xsl:apply-templates select="@*[not(local-name() = 'PFILE')]|node()"/>
          </xsl:copy>

        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
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



  <!-- Handle generic text -->
  <xsl:template match="//db:para/text()">
    <!-- Ignore element if no content is present -->
    <xsl:if test="string-length(normalize-space()) > 0">
      <ITEXT>
        <xsl:attribute name="CH">

          <!-- Normalize space in elements inside paragraph. Insert preseding of trailing space if other nodes exist, like emphasized text or a link. -->
          <!-- NOTE: this forces a spect around emphasized text or link, which could be good -->
          <xsl:if test="preceding-sibling::node()">
            <!-- Don't insert a space if content starts with punctuation, which should typically be appended without space -->
            <xsl:if test="not(contains('.,;:!?…%)]/\”«' ,substring(normalize-space(),1,1)))">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:if>
          <xsl:value-of select="normalize-space()"/>
          <xsl:if test="following-sibling::node()">
            <xsl:text> </xsl:text>
          </xsl:if>

        </xsl:attribute>
      </ITEXT>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
