<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Illustrations

This directory contains the illustrations, including the drawn titles and drawn
capitals.

## Source files

Source files are available in the format of the [GIMP image
editor](https://www.gimp.org/) and are located in two directories:

- source/
- Capitals-source/

## Rendered images

Rendered .png images are present in various directories, based on the contents.
When an illustration is used in multiple translations, it should be placed in a
common directory:

- common/
- common-mirror/
- Capitals-transparent/
- Capitals-source/

## Directories and symbolic links

Symbolic links are used to prevent duplication of files. Each translated
language has a separate directory that contains symbolic links to existing
illustrations that are used in multiple translations. Files unique to the
language are placed in the language directory.

# Capital colors

Different pages use different colors for the capitals.

Some publishers and priting services are not able to handle transparency, which
is why a background color is required. For most pages the background color is
full white.

| Name      | Capital color | Background color |
|-----------|---------------|------------------|
| brown     | #b79b55       | #ffffff          |
| cyan      | #5cb2d4       | #ffffff          |
| fucsia    | #d70071       | #ffffff          |
| green     | #6cba81       | #ffffff          |
| lightcyan | #93ccd3       | #ffffff          |
| olive     | #bcc85a       | #ffffff          |
| pink      | #f5b6cd       | #ffffff          |
| red1      | #e75156       | #fdf08d          |
| red2      | #e64f55       | #ffffff          |
| red3      | #e74c5b       | #ffffff          |
| violet    | #81579a       | #ffffff          |
| yellow    | #f8d66a       | #ffffff          |
| yellow2   | #fddd66       | #71aaa4          |

