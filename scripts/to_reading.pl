#!/usr/bin/perl

# SPDX-FileCopyrightText: 2022-2023 Luca Bonissi
#
# SPDX-License-Identifier: CC0-1.0

if($0=~m/reading/) {
  $pagechange=0;
}
else {
  $pagechange=-1;
}


$status=-1;
$br=0;
while(<>) {
  if($status==-1) {
    if(m/^#/) {
      print;
      $_="";
    }
    else {
      $status=0;
    }
  }
  else {
    if(m/^\[\[/) {
      $status|=0x10;
    }
    if(m/^=== /) {
      $status=1;
      $pagechange=0 if($pagechange>=0);
    }
    elsif(m/^=====/) {
      $status=3;
    }

    if($status>0 && ($status & 0x11)==1) {
      if(m/^===/) {
	if($pagechange>=0) {
	  $pagechange=1;
	}
	else {
	  if(!$br) { print "\n"; }
	  print "\n";
	  $br=1;
	  $_="";
	}
      }
      if($pagechange>0) {
	if(!$br) { print "\n"; }
	($slide)=m/= (.*)/;
	if(length($slide)>0) { $slide="($slide)"; }
	print "<!-- Change Page $slide -->\n\n";
	$_="";
	$br=1;
	$pagechange=0;
      }
      if(m/ $/) {
	chop;
	s/ +$/ /;
      }
      if(m/^\[/) {
	($cap,$rest)=m/\[(.*?)\](.*)/s;
	if(index($cap,"|")) {
	  $cap=substr($cap,index($cap,"|")+1);
	}
	$_=$cap.$rest;
      }
      if(m/^##.*##$|^\*\*.*\*\*$|^\t##/) {
	$_="";
      }
      elsif(m/^$/) {
	if($br) {
	  $_="";
	}
	$br++;
      }
      else {
	$br=0;
      }
      print;
    }
    if(m/^\]\]/) {
      $status&= ~0x10;
    }
    if($status & 0x02) {
      $status=2;
    }
  }
}
