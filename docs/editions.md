<!--
SPDX-FileCopyrightText: 2025 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Editions and notable differences

The editions that have been created until now have minor differences.
Some of those differences are listed here as a summary to assist in the development process.

## German published hard cover

- On page 26 there are 3 paragraphs instead of 4. The English version uses 4, which is carried over into other translations. The English version of 4 paragraph is accepted as a default.

## English

### Published hardcover

- Glue-bound
- On the cover the subtitle is written using a font, compared to the hand drawn letters in the German published hardcover.
- The colophon has a grey section at the bottom pointing to the digital version of the book.
- Page 31 includes a paragraph with a line break. This is not the case for the Spanish translation.

#### English hardcover fonts

- **Cover subtitle:** Caroni regular
- **Back cover endorsements:** Caroni regular, different sizes

### English screen pdf

- Contrary to the hardcover, the subtitle is hand-drawn.
- The screen doesn't include yellow pages with hardware drawings upfront. Other translations do.

#### English screen fonts

- **Cover subtitle:** hand drawn
- **Colophon text:** Heebo Regular 9pt
- **Colophon bold emphasis:** Heebo Bold 9pt
- **Title page subtitle:** hand drawn (same as cover)
- **Body:** Heebo Regular 12pt
- **Page number:** Heebo Bold 10pt
- **Back cover text (summary):** Heebo Regular 12pt

## German

### Published hardbook

- Sewn-bound with a bookmark ribbon
- Inside cover is printed in yellow design with outline drawings

## Spanish screen pdf

- Emphasis (italic font) is used for certain terms hardware and software, including on the cover.
- The colophon contains a grey section, about free not gratis.
- Some protest signs are translated.
- Page 54 with information about the FSFE is formatted with hard newlines.

### Spanish fonts

Heebo font [does not have an italic variant](https://github.com/OdedEzer/heebo/issues/3), so the italic style is artificial and thus depending on the software rendering it.

- **Cover subtitle:** hand drawn
- **Colophon text:** Heebo Regular 9pt
- **Colophon bold emphasis:** Heebo Bold 9pt
- **Colophon italic emphasis:** Heebo Italic (artificial) 9pt
- **Title page subtitle:** hand drawn (same as cover)
- **Body:** Heebo Regular 12pt
- **Body italic emphasis:** Heebo Italic (artificial) 12pt
- **Page number:** Heebo Bold 10pt
- **Back cover text (summary):** Heebo Regular 12pt

## French

### French screen pdf

- A different font is used for the body text.
- The colophon is minimal and doesn't include a statement about free not being gratis.
- There is an additional page after the title page that includes information about the schools involved in the translation.
- A foreword is included upfront on page 7.
- The additional pages upfront have shifted the page numbering, which is resolved by compressing author information to a single page and removing the drawings.
- Information about author and illustrator is grouped on page 56.
- The French text includes spaces before the column character ':', which might be problematic with current DocBook processing of emphasis elements.
- A white font is used on the back cover

#### French Fonts

- **Cover subtitle:** hand drawn
- **Colophon text:** Luciole Regular 8.6025pt
- **Colophon bold italic emphasis:** Luciole Bold Italic 8.6025pt
- **Colophon italic emphasis:** Luciole Italic 8.6025pt
- **Title page subtitle:** hand drawn (same as cover)
- **Credits:** Luciole Regular 8.6025pt
- **Credits bold:** Luciole Bold 8.6025pt
- **Foreword:** Luciole Regular 10.125pt
- **Foreword name bold:** Luciole Bold 10.125pt
- **Foreword function italic:** Luciole Italic 8.6025pt
- **Body:** Luciole Regular 10.125pt
- **Page number:** Luciole Regular 8.6025pt
- **About:** Luciole Regular 9.112499pt
- **About italic emphasis:** Luciole Italic 9.112499pt
- **Colophon end FSFE:** Luciole Regular 8.6025pt
- **Colophon end FSFE emphasis:** Luciole Italic 8.6025pt
- **Colophon end publishing info:** Luciole Regular 8.1pt
- **Back cover text (summary):** Luciole Regular 9pt? (Inkscape import to verify didn't go so well)

### French ebook epub

- Title page includes inline 'Ada & Zangemann' image.
- Background colors are used to support the feel of the image.
- The connectedness at night image is used split, not as a single image containing the entire spread. The protest image is shown three times: once as a single image of the entire spread, then twice a detail of a sign.
- The back cover is used to provide credits to the people what created the digibook.

## Arabic screen pdf

- The book is right-to-left variant.
- In left to right variant some images are flipped, but not all, especially the ones with text. The images on spreads are ordered so they still line up.
- A different font is used.
- Protest banners have been translated using font-based text.
- No dropcaps are used.
- Certain text elements are written in latin font, like the license text, website addresses and an element in the section about illustrator Sandra.

## Italian screen pdf

- The colophon page contains the grey section with free not gratis.
- Protest signs are translated using hand drawn text.
- Last page on screen pdf contains a barcode and price.

### Italian fonts

- **Cover subtitle:** hand drawn
- **Colophon text:** Heebo Regular 9pt
- **Colophon bold emphasis:** Heebo Bold 9pt
- **Title page subtitle:** hand drawn (same as cover)
- **Body:** Heebo Regular 12pt
- **Page number:** Heebo Bold 10pt
- **Back cover text (summary):** Heebo Regular 12pt
- **Back cover price:** Heebo Regular 12pt

## Ukrainian screen pdf

- Titles have been created using fonts.
- A different font is used.
- Protest signs have been translated using hand drawn text.
- Z logo on images has been changed.

## Korean print pdf (work in progress)

- Different fonts are used for body (Freesentation-4Regular) and titles.
