<!--
SPDX-FileCopyrightText: 2021 Free Software Foundation Europe <https://fsfe.org>

SPDX-License-Identifier: CC-BY-SA-3.0-DE
-->

# Generating text file from reading .odp presentation

The primary source for the text to be read during the presentation is 
the .odp, where the text is put inside the presentation notes.

The generated text files are word-wrapped to obtain a maximum line 
length of 72 UTF-8 chars. When a line-break is inserted, the space before 
the line break is preserved, so you can join lines later.

## Simple extraction with automatic naming

To generate the text files (one with "Change Page" indications, the
other without), you have to run the following command.
"Perl" and "unzip" are the only programs required, that normally are 
installed by default in every GNU/Linux system.

```
../extract_text.pl presentation-reading.xx.odp
```

This will create the following 2 files:
* presentation.xx.txt
* presentation-reading.xx.txt

## Customized file names

If you want to customize prefix and suffix, you have to specify them as second 
and third parameters:

```
../extract_text.pl presentation-reading.xx.odp baseprefix .suf
```

This will create 2 files:
* baseprefix.suf.txt
* baseprefix-reading.suf.txt

## Text files header

Usually there should be the file "header.txt", that is prepended to both 
generated text files. If could be, for example, the SPDX header to be
REUSE compliant. If you want to use a customized header, you have to 
specify it as fourth parameters:

```
../extract_text.pl presentation-reading.xx.odp "" "" myheader.txt
```

## Remove automatic line-break

If you want to remove automatic line-break (e.g. to obtain the original 
flowed text), you can use the program unwrap_simple.pl:

```
../unwrap_simple.pl presentation.xx.txt > presentation-flowed.txt
```

# Generate PDF file from presentation

To allow quick loading of the PDF page also from a low-end PC, the suggested 
settings for PDF export are:

* Compress images as JPEG
* Quality: 90%
* Resize to 300 dpi
