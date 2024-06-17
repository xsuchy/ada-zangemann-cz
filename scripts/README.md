<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Scripts

This directory contains scripts to automatically generate book variants based on
templates and the translated text. It also contains a Makefile to easily run
these scripts. Automation allows translators to focus on the text and spend
less time formatting the translation for the various publication formats. The
scripts are linked from the various book translation directories so that these
scripts can easily be executed from the context of a translation.

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

Insert the translation in one of the [Scribus](https://www.scribus.net/)
templates or .odp presentation templates. These Scribus files are used for the
printed book (cover and contents) as well as pdf format.

### to_odp.pl

Insert the translation in the .odp presentation notes, to be used for
reading sessions. As template you can use an .odp file from other languages.

### to_pdf.sh

Automatically generate a pdf file from a Scribus .sla file. The output filename
is determined by replacing the file extension to .pdf. Scribus will show a user
interface while doing the conversion.

```shell
$ ./to_pdf.sh ../Book/nl/nl-screen.sla
```

### unwrapada.pl

Remove hard line breaks so that each paragraph is on a single line. This unwraps
hard line breaks preceded by a space.

```shell
$ ./unwrapada.pl Ada_Zangemann-en.txt > Ada_Zangemann-en-unwrapped.pl
```

### wrapada.pl

Add hard line breaks in lines to limited the length. Each line is wrapped on a
whole word to stay in a length of maximum 72 characters.

```shell
$ scripts/unwrapada.pl Ada_Zangemann-en.txt > Ada_Zangemann-en-unwrapped.pl
```

Line breaks with a preceding space signify a continuation of the paragraph.
These types of line breaks are not treated as a special case. So in order to
change the line breaks inside paragraphs, the unwrapdata.pl and wrapada.pl
scripts can be combined:

```shell
$ cat Ada_Zangemann-en.txt | scripts/./unwrapada.pl | scripts/./wrapada.pl > Ada_Zangemann-en-unwrapped.pl
```

### Makefile

The typical tasks of generating output files is simplified using GNU Make. For
each output file a job has been defined. All available output jobs can be
called using the 'make all' command. Some examples:

```shell
$ make help
$ make clean
$ make nl-screen.sla
$ make all
```

### scribus_pdf.py

This is not a script to be run directly. It is a script that can be called from
Scribus to automatically generate a pdf file. This process is automated in the
to_pdf.sh script.

## Compatiblity and development

There is currently no versioning of scripts and source texts. Changes in scripts
are combined with changes in source texts and templates. Translations should be
committed upstream to benefit from these ongoing improvements.
