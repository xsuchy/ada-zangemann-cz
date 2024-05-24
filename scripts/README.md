<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Scripts

This directory contains scripts to automatically generate book variants based on
templates and the translated text. Automation allows translators to focus on the
text and spend less time formatting the translation for the various publication
formats. The scripts are linked from the various book translation directories so
that these scripts can easily be executed from the context of a translation.

## Usage

The scripts print their use when called without arguments. Typically the source
text is taken as the first argument and a template as second argument if the
script requires a template. Output is typically provides to stdout and needs to
be directed to a file in order to write to disk.

Example of rendering a Scribus file

```shell
$ cd Book/en/
$ ./to_scribus.pl Ada_Zangemann-en.txt template-print.sla > rendered-print.sla
```

## Scripts overview

Different scripts are available for different purposes:

### to_reading.pl

Create a script for book readings. The final text includes hints for changing
slides in the book reading presentation, based on slide change hints in the
source text.

### to_scribus.pl

Insert the translate in one of the [Scribus](https://www.scribus.net/) templates
or .odp presentation templates. These Scribus files are used for the printed
book (cover and contents) as well as pdf format.

### to_text.pl

_Needs a description._

### unwrapada.pl

_Needs a description._

### wrapada.pl

_Needs a description._

## Compatiblity and development

There is currently no versioning of scripts and source texts. Changes in scripts
are combined with changes in source texts and templates. Translations should be
committed upstream to benefit from these ongoing improvements.
