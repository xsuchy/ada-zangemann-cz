<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Printing

There are multiple Scribus templates for different outputs:

- **screen.sla** without cut marks for viewing on screens
- **print.sla** internal part for printing with cut marks
- **coversoft.sla** outside cover for soft cover edition
- **coverhard.sla** outside cover for hard cover edition

## Booklet printing

You can print a downscaled booklet at home on double sided A4 paper. Scribus is
not able to output an ordered pdf that is set up for booklet printing.
Creating a booklet pdf from the Scribus pdf output can be done using additional
programs. One such program is [PDF Mix Tool](https://scarpetta.eu/pdfmixtool/).
Using such software you can generate a pdf that has two pages on a single page,
intended for the tsack to be stapled or sown through the middle of the paper.

When printing, make sure to select double sided printing when available and to
configure double sided according for the right orientation (short side).

## Publishing

It takes additional work to take the rendered Scribus files and get them
published. This paragraph is a generic overview to highlight the steps involved.

Get in touch with FSFE if you want to publish, so we can help out from our
experience.

1. Purchase ISBN code(s) for the book
1. Adjust layouts to printer specifications (size, margins and color)
1. Create covers for publishing
   - Relevant logo's (FSFE and others involved)
   - ISBN barcode on the back
   - Optionally include price
1. Generate pdfs for printing
1. Final proofread before ordering
1. Archive files for the future (at FSFE)

ISBN barcodes can be generated in Scribus and in Inkscape.
