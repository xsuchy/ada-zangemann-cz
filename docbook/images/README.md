<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Images

This directory contains images used in the book: illustrations, capitals and logos.

## Linking images from other directories

Linking common images:

```
find ../../../illustrations/common/ -exec ln -s {} \;
```

Linking language-specific images:
```
cd illustrations; find ../../../illustrations/da/ -iname '*-da.png*' -exec ln -s {} \;
```

Linking opague images:
```
ln -s ../../illustrations/Capitals_opaque capitals-opague
```
