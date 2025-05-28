<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Images

This directory contains images used in the book: illustrations, capitals and logos.

## Linking images from other directories

Linking common images:

```
cd illustrations;
find ../../../illustrations/common/ -exec bash -c 'ln -s {} $( file=$(basename {} ); echo "${file/.png/.ltr.png}")' \;
```

Linking language-specific images:
```
cd illustrations;
LANG="pt_PT"; find ../../../illustrations/$LANG/ -iname "*-${LANG}.png*" -exec bash -c 'ln -s {} $( file=$(basename {} ); echo "${file/-${LANG}./.${LANG}.}")' \;
```

Linking opague images:
```
ln -s ../../illustrations/Capitals_opaque capitals-opague
```
