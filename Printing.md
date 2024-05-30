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
intended for the tsack to be stapled or sown throught the middle of the paper.

When printing, make sure to select double sided printing when available and to
configure double sided according for the right orientation (short side).
