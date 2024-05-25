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
