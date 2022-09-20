#!/usr/bin/perl

# SPDX-FileCopyrightText: 2022 Luca Bonissi
#
# SPDX-License-Identifier: CC0-1.0

use utf8;

$file=shift;
$base=shift;
$postfix=shift;
$header=shift;

$wrap=72;
$remove_space=0;

sub Wrap {
  my $text=shift;
  my($i,$ch,$s);

  foreach $line (split("\n",$text))
  {
    while(length($line)>$wrap)
    {
      $i=$wrap;
      $ch=substr($line,$i,1);
      while($i>=0 && $ch ne " " && $ch ne chr(9))
      {
	$i--;
	$ch=substr($line,$i,1);
      }
      if($i>=0)
      {
	$i++;
	$s.=substr($line,0,$i-$remove_space)."\n";
	$line=substr($line,$i);
      }
      else
      {
	$s.=substr($line,0,$wrap)."\n";
	$line=substr($line,$wrap);
      }
    }
    $s.=$line."\n";
  }
  return($s);
}

sub Write
{
  my $file=shift;
  my $text=shift;
  if(open(W,">$file"))
  {
    binmode(W,":utf8");
    if(open(H,$header)) {
      binmode(H,":utf8");
      while(<H>) { print W; }
      close(H);
    }
    print W $text;
    close(W);
  }
  else 
  {
    print STDERR "Error opening $file for writing: $!\n";
  }
}


###### MAIN #######

if(length($file)==0) {
  print STDERR "Usage: <odp_file> <output_file_base>\n";
  exit(1);
}

if(length($base)==0) {
  ($postfix)=($file=~m/(\.\S+?)\.odp$/i);
  $base=$file;
  $base=~s/\.\S+?\.odp$//i;
  $base=~s/-reading$//i;
}

if(length($header)==0) {
  $header="header.txt";
}

if(!open(F,"unzip -q -c \"$file\" content.xml|"))
{
  print STDERR "Cannot open/unzip $file: $!\n";
  exit(2);
}

binmode(F,":utf8");
binmode(STDOUT,":utf8");

# Buffering
$buf="";
while(<F>)
{
  $buf.=$_;
}
close(F);

# Extract raw presentation notes:
@pn=($buf=~m|<presentation:notes.*?>.*?<draw:text-box>(.*?)</draw:text-box>.*?</presentation:notes>|gis);

$text_clean="";
$text_turn="";

$count=0;
foreach $pn (@pn)
{
  # Extract plain text for each presentation note:
  $text="";
  $last="";
  $i=0;
  while(($i=index($pn,"<text:p",$i))>=0) {
    $i2=index($pn,">",$i);
    if($i2>0) {
      $i3=index($pn,"/>",$i);
      if($i3>0 && $i3<$i2) {
	# Empty line;
	$last.="\n";
	$i=$i2;
      }
      else {
	$text.=$last;
	$last="";
        $i=$i2+1;
	$i2=index($pn,"</text:p>",$i);
	if($i2>0) {
	  $t2=substr($pn,$i,$i2-$i);
	  $t2=~s/[ \t]+$//;
	  $text.=$t2."\n";
	}
	else {
	  # Something wrong, cannot find end-paragraph....
	  print STDERR "text xml tag not closed, getting text to the end\n";
	  $text.=substr($pn,$i+8)."\n";
	  $i=length($pn);
	}
      }
    }
    else {
      print STDERR "xml tag not terminated, aborting current note\n";
      $i=length($pn);
    }
  }
  if(length($text)>0) {
    $text=Wrap($text);
    $text_clean.=$text."\n\n";
    $text_turn.=$text."\n<!-- Change Page -->\n\n";
    $count++;
  }
}

Write("${base}-reading$postfix.txt",$text_turn);
Write("${base}$postfix.txt",$text_clean);

print "Processed $count notes.\n";
