<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# DocBook trial

## Considerations

Considerations for the current DocBook format.

### Arguments for choosing DocBook

- DocBook is designed for books, the main format of the Ada Zangemann story.
- Exensibility of XML allows additional information for other formats like the presentation.
- DocBook is very well documented, including recommendations on modeling information and expectations for processing.
- Popular document processors rely on DocBook for certain output formats (Asciidoctor) or support DocBook as a format for input and output (Pandoc).
- XML enables the use of other XML standards (e.g. [ITS](https://www.w3.org/TR/its/) for internationalisation) and custom elements and attributes to add information.
- Support for reading and writing XML is available in most programming languages, often even in the standard library. This makes it easy for others to write a program that can read from the source format
- XML supports linking and including inforation.
- XSLT is a standard format of defining conversions. XSLT templates exist for DocBook for various output formats (HTML, PDF, Epub). Some of these conversions can be reused as they are modular.
- XML can be validated using a schema to prevent errors.
- XML and DocBook are open standards, but so are many other formats.
- A downside of XSL is the verbosity, which can be overwhelming for newcomers. By enabling integration with .po translation files most people won't have to work with the source format and can focus on the content.
- Other formats considered were Markdown, Pandoc Markdown, Asciidoc, Asciidoctor, Restructured Text.
- Based on the latest [DocBook 5.2](https://tdg.docbook.org/tdg/5.2/) which is currently in development.

### Implementation details

- A Docbook namespace is used ([suppored since Docbook 5.0](https://tdg.docbook.org/tdg/5.2/ch01#introduction-ns)) to enable namespaced extensions specific to Ada and Zangemann.
- DocBook describes recommended use of elements and attributes and 'processing expecations' how processors are supposed to handle the elements.
- There can be multiple ways to convey/express/model the same contents. The final modelling is a design decision. The modeling might be revisited in the future based on experiences and changes in DocBook format and parsers.
- XML ITS is used to mark the content that can be translated. It also enables the use of translator notes. See the [documentation](https://www.w3.org/TR/its/) about available elements.
  - [ITS Tool](https://itstool.org/) supports exporting and importing PO files for translations.
    - ITS Tool automatically adds information about the path in the document. It also adds translator notes for filerefs, clarifying what they are for. Custom elements also get handled.
  - Translators and proofreaders are to be registered using [book/info/othercredit elements](https://tdg.docbook.org/tdg/5.2/othercredit) as this is built-in into Docbook. The ITS standard allows registering translators using [provenance information](https://www.w3.org/TR/its/#provenance) which is more complicated to support registering more exact author information. The DocBook othercredit seems sufficient.
- XSLT templates should ideally focus on XSLT version 1.0 with minimal extensions. Basically the featureset of the popular free software Xsltproc software as part of [Libxml2](https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home). XSLT 2.0 and 3.0 introduce convenient functions and come with more current processing templates.
  - DocBook processing templates for XSLT 1.0 are [available online](https://github.com/docbook/xslt10-stylesheets) and are available in many Linux distributions.
  - XSLT 3.0 had multiple benefits, as is argued in [this blogpost from 2017](https://www.xml.com/articles/2017/02/14/why-you-should-be-using-xslt-30/). The [xsltNG](https://github.com/docbook/xslTNG) Docbook XSLT Stylesheets use XSLT 3.0. These stylesheets are a reason to adopt XSLT 3.0. [Saxon XSLT](https://en.wikipedia.org/wiki/Saxon_XSLT) is the only free software XSLT 3.0 processor, which is a reason to be reluctant in using XSLT 3.0. [Xrust](https://crates.io/crates/xrust) is a XSLT 3.0 engine being developed in Rust which might end up becoming the second free software solution.
- UTF-8 encoding is selected to support more special characters and hot have to escape as much characters. The ampersand '&' character still must be escaped as `&amp;` because the ampersand is used in XML as an escape character itself.
- `az:dropcap="true"` are used on `<para>` elements to indiate that the paragraph starts with a drop cap, a larger colorful capital.
- The `<alt>` element is used in a `<mediaobject>` to provide the description for an image.
- A custom `<az:excerpt>` element is used to model the text on an image, for translation purposes. Even if the image is not updated directly, it might be done at some point in the future.
- The data modeling version is represented using the `az:datamodelversion="0.1.0-alpha"` attribute in the main `book` element. Previously this was a custom element `<az:datamodel version="0.1.0-alpha"/>` but that did end up in the default XSLT template rendering. The XML namespaces also include version, but this does not consider how the elements are being used.
- Elements can be made easier to link or lookup by adding an `xml:id` attribute ([documentation](https://www.w3.org/TR/xml-id/)). Benefits of using these identifiers is that they are common, can be used for linking within the document and verified by tools like Xmllint to be unique in the document.
- Custom elements in DocBook end up in the output when processing with standard XSLT templates. For this reason standard DocBook elements are used to signify pages and slide transitions.
- The contents is separators for slides using `<anchor az:slidenum="n"/>` tags. Initially the idea was to use ustom `<az:slide/>` elements are used to describe slide transitions for the book reading presentations. As the custom elements end up in the output using default processing templates, so standard DocBook elements are used instead. There is a [DocBook Slides](https://tdg.docbook.org/tdg/slides/5.2/) format for presentations, but this cannot coexist with the DocBook format. The main focus would be to add [speakernotes](https://tdg.docbook.org/tdg/slides/5.2/sl.speakernotes) elements for the reading text. Any desired presentation-oriented format can be achieved by processing according the custom elements. Also `xml:id` identifiers might be used as a more standard attribute for identifiers.
- Chapters have the `<title>`, `<subtitle>` and `<titleabbrev>` attributes inside the `<info>` element. This is more verbose but is considered a best practice for more elaborate information elements and the hierarchy can help in processing. In the standard DocBook XSLT 1.0 templates this also renders better, as direct use of `<title>` in the chapter results in space.
- Preferably [common attributes](https://tdg.docbook.org/tdg/5.2/ref-elements#common.attributes) are used to add information to elements.
- xlink href is used for external links, as suggested in the [DocBook documentation](https://tdg.docbook.org/tdg/5.2/link).
- The `dir` attribute is set to signify the direction of text (and images). This can be `ltr` for left-to-right or `rtl` for right-to-left. This very much depends on the language. Other values `lro` and `rlo` exist as override values to override the direction for a short section. See also the [XHTML documentation](https://www.w3.org/TR/xhtml2/mod-bidi.html).
- Custom models are used for elements in the book which are not the main story. This concerns the colophon, appendix and acknowledgements.
  - Docbook doesn't have a model for a titlepage. Instead the common practice is to print a page containing the title and subtile. This can be observed from this example of [pdf generation](https://doccookbook.sourceforge.net/html/en/dbc.fo.design-titlepages.html).
- All involved persons have been modelled as persons to reveive credit in the main info. This increases the complexity in the modelling, but is more precise in the metadata. As the information is already in the colophon, it might as well be removed.
- Custom elements are used inside the book info element to list the named characters in the story. This allows translators to document the chosen names in case they deviate.
- Font information is added to in book/info using custom elements (az:style/az:fontset/az:font). Especially languages using non-latin charachters might require different fonts. Adding this information into the DocBook document breaks the DocBook principle of separating formatting and content. Adding it in the same file brings conveniencefor processors by having the information available in one structure.
- Use itstool extension [itst:credits](https://itstool.org/documentation/extensions.html#credits) to enable translators to insert translator credits into the document. This information is represented as othercredit.

#### Ideas for consideration
- To add to each paragraph (`<para>` or `<literallayout>`) an `az:pagenum` attribute for easier parsing. This enables parsers to select all paragraphs with this attribute that should end up on a given page. Alternatively is to use `<az:page num="n"/>` elements to separate pages or use DocBook sections to split a chapter into separate pages. Note that sections would have to be defined within a chapter, making it more difficult to get the title, requiring navigation up the element tree.
- To create a script for validating the code using Xmllint and for making improvements lik replacing three dots with an ellipsis character.
- A DocBook [remark](https://tdg.docbook.org/tdg/5.2/remark) could be to mark 'remix' and 'draft' editions.
- It should be possible to specify whether the language is RTL or LTR. It might be concluded based on the language too.
- The additional elements appear in the final rendered output. Have observed it with `<az:datamodel/>`, `<az:page/>` and `<az:slide/>` using the default XSLT 1.0 HTML templates.
- More refinement is necessary on the `<section>` elements for the page numbers. It results in a table of contents per chapter.
- How best to model title and subtitle on the cover. A title isn't allowed. It could be ommitted as it is already present on the book info. A bridgehead seems fitting, but a para might do.
- Use [parameters for 'profiling'](https://tdg.docbook.org/tdg/5.2/ref-elements#common.effectivity.attributes) to make certain formatting conditional, depending on output format or a generic condition.
- Provide XSLT transformation to remove custom attributes and ensure it to be standard DocBook.
- Provide XSLT transformation to convert to DocBook slides for presentation.
- For formatting take inspiration from [XSL-FO](https://en.wikipedia.org/wiki/XSL_Formatting_Objects) designed for formatting pdf files.
- Use the [markup](https://tdg.docbook.org/tdg/5.2/markup) element to mark a piece of text for markup.
- A [phrase](https://tdg.docbook.org/tdg/5.2/phrase) can be used to mark a piece of text.
- The default XSLT 1.0 HTML processing changes the order of the book by moving the acknowledgments to the front. This is standard for most books, but is undesireable for the childrens book. So even though the modelling is more correct, the end result requires more customisation.
- Some alt text descriptions are quite lengthy and couuld benefit from a split. Docbook doesn't seem to offer such a feature.
- It could be interesting if initial stylesheets could be included so that the document can be converted to some basic outputs.
- Addresses from the publishers and from Creative Commons could be represented using an [address](https://tdg.docbook.org/tdg/5.2/address) element. This resulted in unwanted newlines in the XSLT 1.0 HTML output, which was the reason to not use it for now.
- Deal with conditional credits or colophon, as the English version has 2 versions: for print and for online publication. It might be that there are two version of the source document: one representing the published book and one being the upstream document version for remix versions.
- It might be necessary or convenient to add font properties for emphasis markup, because the terms used for bold and italic might depend on the font.
- Use `xml:id` attributes on the chapters for identification or reference. Could be an identifier like `ch01` or a more descriptive text.

Consider modelling the dropcaps as inline images, perhaps conditionally. Making this conditional and dealing with alt-text is a challenge.

```xml
<para>
  <inlinemediaobject>
    <imageobject>
      <imagedata fileref="../illustrations/Capitals/O-cyan.png"/>
    </imageobject>
    <alt>O</alt>
  </inlinemediaobject>
  nce upon a time, there was a little girl named Ada. Her family was so poor that all their savings fit inside a cookie jar. They didn’t have enough money to live in a proper home. Instead, Ada lived with her mother and her little brother, Alan, in a cabin near a junkyard on the edge of town.
</para>
```

- Consider using the [ITSTool extension for credeits](https://itstool.org/documentation/extensions.html#credits) that is explicit on where credits of translators should end up.
- Use ITS rules to add basic locNotes to all attributes, especially the `<alt>` tags. A link to the general translation notes would also be helpful.
- The ITS rules require tweaking to be as precise to select the content for translation and discard the document structure that shouldn't be modified by translators.
- The dropcaps attributes on the para elements are not available for translation by default. That might need work to make it part of the internationalisation.

Consider having multiple imageobjects for different conditions:

```xml
<mediaobject xml:id="img-ada-04">
  <imageobject condition="print">
    <imagedata fileref="figs/print/ada-04.png"/>
  </imageobject>
  <imageobject condition="web">
    <imagedata fileref="figs/web/ada-04.png"/>
  </imageobject>
</mediaobject>
```

### Recommendations for ongoing development

- A change in modeling might be breaking for external scripts. Breaking changes should be avoided. A version indicator is a hint at format compatibility.

### Software stack

- Many text editors support XML formatting and some even recognize the DocBook format.
- [ITS Tool](https://itstool.org/) supports exporting and importing PO files for translations.
- [Libxml2](https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home) is a popular free software tool to work with XML.
  - Xmllint allows validating and reformatting the XML source text.
  - Xsltpoc supports processing using XSLT templates of version 1.0 and some convenient extensions. XSLT versions 2.0 and 3.0 exist as well, but are not supported by Libxml2.

## Some commands

    xsltproc -o output.xml --verbose --stringparam docbook-contents-file "Ada_Zangemann-en.dbk" xsl/scribus-2.xsl template-print-1.sla

    diff -C2 template-print-1.sla output.xml

    xsltproc -o docbook-xslt.html /usr/share/xml/docbook/stylesheet/nwalsh/html/docbook.xsl Ada_Zangemann-en.dbk

    pandoc -f docbook -t html -o docbook.html Ada_Zangemann-en.dbk

    itstool -o source.pot Ada_Zangemann-en.dbk

## Resources

The DocBook standard is large and will take time to comprehend. It will take more time if you include the XML standard, the XSLT processing standard, the ITS internationalisation standard and the various tools. Fortunately there are great resources like documentation, books, videos and an active community.

### DocBook

- [DocBook book website](https://docbook.org/) which includes links to different resources
  - [Overview of DocBook version 5 customizations](https://docbook.org/schemas/5x-custom) like DocBook Slides
- [DocBook wiki](https://github.com/docbook/wiki/wiki) with various articles
- [DocBook online book for version 5.2](https://tdg.docbook.org/tdg/5.2/) currently in development
- There used to be a DocBook mailinglist hosted by OASIS. A new one might be created.

### XSLT and XPath

XSLT can be used to express transformations of XML, much like a programming language. XPath is the way in which XSLT templates select certain parts of the XML document for processing.

- [XSLT section in the XML Wikibook](https://en.wikibooks.org/wiki/XML_-_Managing_Data_Exchange/XSLT_and_Style_Sheets)
- [XPath wikibook](https://en.wikibooks.org/wiki/XPath)
- [YouTube XSLT XPath Tutorial video](https://www.youtube.com/watch?v=WggVR4YI5oI) that goes into the practical aspects and pitfalls.
- [XML Prague](https://www.xmlprague.cz/) is a yearly conference focussed on XML and related standards. Talks are recorded and available online.

Some examples of XSLT intended for DocBook:

- [XSLT 1.0 stylesheets for DocBook](https://github.com/docbook/xslt10-stylesheets)
- [XSLT 3.0 stylesheets for DocBook](https://github.com/docbook/xslTNG) which includes conversions for Epub output.
- [Docbook2SLA Python package](https://pypi.org/project/docbook2sla/) that contains XSLT conversions for DocBook to Scribus and vice versa. The source code has been extracted from the source packages to [this repository](https://gitlab.com/nicorikken/docbook2sla)

<!-- TODO: add details on Scribus and XML tooling -->

## Schema summary

A brief overview of the Docbook elements and custom attributes used in the source format.

```xml
<?xml az:datamodelversion="0.1.0-alpha"/>
<book>
  <info>
    <title/>
    <subtitle/>
    <author>
      <personname/>
    </author>
    <copyright/>
    <legalnotice/>
    <author/>
    <othercredit class="illustrator"/>
    <othercredit class="translator"/> # or proofreader, reviewer
    <az:style>
      <az:fontset condition="scribus">
        <az:font role="body">
          <az:fontfamily>Heebo</az:fontfamily>
          <az:fontstyle>regular</az:fontstyle>
          <az:fontsize>12pt</az:fontsize>
          <az:fonthref>https://github.com/OdedEzer/heebo</az:fonthref>
          <az:fontlicense>OFL-1.1</az:fontlicense>
        </az:font>
      </az:fontset>
    </az:style>
    <az:namedcharacters>
      <az:character role="ada">
        <az:charactername>Ada</az:charactername>
        <az:characternameorigin>Ada Lovelace</az:characternameorigin>
      </az:character>
    </az:namedcharacters>
    <cover role="front"/>
    <cover role="back"/>
  </info>
  <colophon/>
  <chapter xml:id="ch1">
    <info>
      <title/>
      <subtitle/>
      <titleabbrev/>
    </info>
    <anchor az:slidenum="1"/>
    <section az:pagenum="1">
      <literallayout/>
      <para az:dropcap="true"/>
        <emphasis role="bold"/>
        <link xlink:href="https://ada.fsfe.org">https://ada.fsfe.org</link>
      </para>
      <mediaobject>
        <imageobject>
          <imageobject condition="print">
            <imagedata fileref="figs/print/ada.png"/>
          </imageobject>
        </imageobject>
        <alt/>
      </mediaobject>
    </section>
  </chapter>
  <appendix/>
</book>
```

## Analysis of slides and pages

Slide transitions and page transitions cross each oter (single page for multiple slides and vice-versa).

Conclusion is that slide transitions will have to be done using a custom element (anchor).
Alternatively more sections could be created for which duplicate entries of pagenum and slidenum are allowed.

NOTE: the resulting Table of contents in HTML gets additional spaces inserted when sections are introduced.

| contents              | page  | slide |
|-----------------------|-------|-------|
| Title pagee           | 1     | X     |
| Frontmatter           | 2     | X     |
| Title                 | 3     | 1     |
| Ada & Zangemann       | 4-5   | 2     |
| Zangemann & Computers | 6-7   | 3     |
| (continued)           | 8-9.1 | 4     |
| (continued)           | 9.2   | 5     |
| (continued)           | 10-11 | 6     |
| (continued)           | 12    | 7     |
| One day...            | 13    | ..    |

