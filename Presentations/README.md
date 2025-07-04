<!--
SPDX-FileCopyrightText: 2021 Free Software Foundation Europe <https://fsfe.org>
SPDX-FileCopyrightText: 2025 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-3.0-DE
-->

# Book reading presentations and texts

This folder contains generated presentations and texts for book readings.
It contains the automation to create or update them.

Practical guidance for organizing a book reading can be found in the [Readings Organisation documentation](../docs/readings-organisation.md).

It is a known [issue that the resulting presentations do not open correctly on Windows](https://git.fsfe.org/FSFE/ada-zangemann/issues/52).
You can use an existing pdf presentation or contact FSFE for assistance.

## Generating text file for reading

The primary source for the text to be read during the presentation is the text
file in the presentation.

The generated text files are word-wrapped to obtain a maximum line length of 72
UTF-8 chars. When a line-break is inserted, the space before the line break is
preserved, so you can join lines later.

### Running the script

To generate the text files (one with "Change Page" indications, the other
without), you have to run the following command. "Perl" is the only program
required, that normally is installed by default in every GNU/Linux system.

```
./create_reading.sh <langcode>
```

This will create the following 2 files:

* ada-zangemann.xx.txt
* ada-zangemann-reading.xx.txt

### Remove automatic line-break

If you want to remove automatic line-break (e.g. to obtain the original flowed
text), you can use the program unwrap_simple.pl:

```
../unwrap_simple.pl presentation.xx.txt > presentation-flowed.txt
```

## Generate PDF file from presentation

To allow quick loading of the PDF page also from a low-end PC, the suggested
settings for PDF export from ODP are:

* Compress images as JPEG
* Quality: 90%
* Resize to 300 dpi
