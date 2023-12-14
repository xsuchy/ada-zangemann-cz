#!/usr/bin/perl

# SPDX-FileCopyrightText: 2022-2023 Luca Bonissi
#
# SPDX-License-Identifier: CC0-1.0

use utf8;

$s=STDIN;
$file=shift;
if(length($file)>0) { 
  if(!open($s,"$file")) {
    print STDERR "Cannot open file $file: $!\n";
    exit(1);
  }
}
binmode($s,":utf8");
binmode(STDOUT,":utf8");
while($line=<$s>)
{
  if(substr($line,-2) eq " \n" && substr($line,-3) ne "  \n") {
    chop($line);
  }
  print $line;
}
