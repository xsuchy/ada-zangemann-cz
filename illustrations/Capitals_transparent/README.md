<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Capitals_transparent

Capitals in .png format with a transparent background.

## Generate new colors

As each page requires a different color of capital it is likely that a
translation requires new colors of existing capital letters. These colors can be
created by recoloring existing transparent capitals. This is automated using the
new-color.sh shell script.

Provide the new-color.sh shell script with the filename of the desired output
file. The script looks up an existing capital for the same character and
recolors it based on the color name.

Example usage:

```shell
$ ./new-color.sh E-brown.png
$ ./new-color.sh Shta-red3.png
```
