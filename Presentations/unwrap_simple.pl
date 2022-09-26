#!/usr/bin/perl

# SPDX-FileCopyrightText: 2022 Luca Bonissi
#
# SPDX-License-Identifier: CC0-1.0

while(<>) {
  chop;
  if(!m/ $/) { $_.="\n"; $last="";}
  else {
    $last="\n";
  }
  print;
}
