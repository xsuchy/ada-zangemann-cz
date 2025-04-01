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

## Capital colors

Different pages use different colors for the capitals.

Some publishers and printing services are not able to handle transparency, which
is why a background color is required. For most pages the background color is
full white.

| Name      | Capital color | Background color | Use               |
|-----------|---------------|------------------|-------------------|
| brown     | #b79b55       | #ffffff          | ch7-p25           |
| cyan      | #5cb2d4       | #ffffff          | ch1-p04, ch11-p39 |
| fucsia    | #d70071       | #ffffff          | ch5-p20           |
| green     | #6cba81       | #ffffff          | ch10-p36          |
| lightcyan | #93ccd3       | #ffffff          | ch6-p22           |
| olive     | #bcc85a       | #ffffff          | ch4-p18           |
| pink      | #f5b6cd       | #ffffff          | (ch9)-p35         |
| red1      | #e75156       | #fdf08d          | ch2-p06           |
| red2      | #e64f55       | #ffffff          | ch8-p26           |
| red3      | #e74c5b       | #ffffff          | ch13-p44          |
| violet    | #81579a       | #ffffff          | ch12-p42          |
| yellow    | #f8d66a       | #ffffff          | ch9-p30, ch14-p48 |
| yellow2   | #fddd66       | #71aaa4          | back-cover        |

## Generate new colors of existing capitals

As each page requires a different color of capital it is likely that a
translation requires new colors of existing capital letters. These colors can be
created by recoloring existing transparent capitals. This is automated using the
new-color.sh shell script.

Provide the new-color.sh shell script with the filename of the desired output
file. The script looks up an existing capital for the same character in the
Capitals\_transparent directory and recolors it based on the color name. The
resulting capitals end up in the Capitals\_transparent and Capitals\_opaque
directory.

Example usage:

```shell
./new-color.sh E-brown.png
./new-color.sh Shta-red3.png
```
