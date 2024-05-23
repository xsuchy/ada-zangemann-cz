#!/usr/bin/perl

# SPDX-FileCopyrightText: 2022-2023 Luca Bonissi
#
# SPDX-License-Identifier: CC0-1.0

$TXT=0;
$ODP=1;
$SLA=2;
$REA=3;
$EPU=4;

$format=$TXT;

if($0=~/scribus/) {
  $format=$SLA;
}
elsif($0=~/odp/) {
  $format=$ODP;
}
elsif($0=~/reading/) {
  $format=$REA;
}
elsif($0=~/epub/) {
  $format=$EPU;
}


$textfile=shift;
$templatefile=shift;
$templatedir=shift;

if(length($textfile)==0 
   || (($format==$SLA || $format==$ODP) && length($templatefile)==0)
   || (($format==$ODP) && length($templatedir)==0)
  ) {
  if($format==$SLA) {
    print STDERR "\nUsage: $0 source.txt template.sla > destination.sla\n\n";
  }
  elsif($format==$ODP) {
    print STDERR "\nUsage: $0 source.txt template.odp destination.odp\n\n";
  }
  else {
    print STDERR "\nUsage: $0 source.txt > destination.txt \n\n";
  }
  exit(1);
}

$language=$textfile;
$language=~s/-source//;
$language=~s/\.txt//;
if($i=rindex($language,"-"))
{
  $language=substr($language,$i+1);
}
else
{
  $language="en";
}

if(!open(F,$textfile)) {
  print STDERR "Error opening $textfile: $!\n";
  exit(1);
}

sub RemoveLF {
  my $pagetext=shift;
  $pagetext=~s/^\n+//gs;
  while(length($pagetext)>0 && substr($pagetext,-1) eq "\n") { 
    chop($pagetext);
  }
  return($pagetext);
}

sub Unformat {
  my $s=shift;
  $s=~s|<b>||gis;
  $s=~s|</b>||gis;
  $s=~s|<i>||gis;
  $s=~s|</i>||gis;
  return($s);
}

sub FormatXML {
  my $s=shift;
  $s=~s/\&/\&amp;/gs;
  $s=~s/"/\&quot;/gs;
  $s=~s/</\&lt;/gs;
  $s=~s/>/\&gt;/gs;
  return($s);
}

sub ReplaceFormat
{
  my ($par,$fmt,$font)=@_;
  my ($i,$f,$c0,$c1,$c2,$lc,$ofmt,$cfmt);
  $lc=lc($par);
  # Check for bold
  $c0=0;
  $ofmt="<$fmt>";
  $cfmt="</$fmt>";
  while(($c1=index($lc,$ofmt,$c0))>=0) {
    if($c1>$c0) {
      $f.=substr($par,$c0,$c1-$c0);
    }
    $c1+=length($ofmt);
    $c2=index($lc,$cfmt,$c1);
    if($c2>$c1) {
      $f.="<ITEXT FONT=\"$font\" CH=\"".FormatXML(substr($par,$c1,$c2-$c1))."\"/>";
      $c0=$c2+length($cfmt);
    }
    else {
      # Wrong formatting...
      $f.=substr($par,$c1);
      $c0=length($lc);
    }
  }
  if($c0<length($lc)) {
    $f.=substr($par,$c0);
  }
  return($f);
}

sub FormatSLA {
  my $s=shift;
  my $space=shift;
  my (@par,$i,$f,$c0,$c1,$c2,$lc,$slocal,$ofmt,$cfmt);
  @par=split("\n",$s);
  for($i=0;$i<=$#par;$i++) 
  {
    $slocal=$par[$i];
    $slocal=ReplaceFormat($slocal,"b",$bold);
    $slocal=ReplaceFormat($slocal,"i",$italic);
    $slocal=ReplaceFormat($slocal,"bi",$bolditalic);
    $lc=$slocal;
    # Place XML tags
    $c0=0;
    $ofmt="<ITEXT ";
    $cfmt="\"/>";
    while(($c1=index($lc,$ofmt,$c0))>=0) {
      if($c1>$c0) {
	$f.=$space."<ITEXT CH=\"".FormatXML(substr($slocal,$c0,$c1-$c0))."\"/>\n";
      }
      $c2=index($lc,$cfmt,$c1);
      if($c2>$c1) {
	$c2+=length($cfmt);
	$f.=$space.substr($slocal,$c1,$c2-$c1)."\n";
	$c0=$c2;
      }
      else {
	# Wrong formatting...
	$f.=$space."<ITEXT CH=\"".FormatXML(substr($slocal,$c1))."\"/>\n";
	$c0=length($lc);
      }
    }
    if($c0<length($lc)) {
      $f.=$space."<ITEXT CH=\"".FormatXML(substr($slocal,$c0))."\"/>\n";
    }
    if($i<$#par) {
      $f.=$space."<para/>\n";
    }
  }
  return($f);
}


$status=-1;
$pagechange=0;
$br=0;
$pagenum=0;
while(<F>) {
  if($status==-1) {
    if(m/^#/) {
      print if($format==$TXT || $format==$REA);
      $_="";
    }
    else {
      if($format==$REA) { $status=0; }
      else { $status=1; }
    }
  }
  else {
    if(m/^\[\[/) {
      $status|=0x10;
    }
    if($format==$REA) {
      if(m/^=== /) {
	$status=1;
	$pagechange=0 if($pagechange>=0);
      }
      elsif(m/^=====/) {
	$status=3 if($format==$REA);
      }
    }
    elsif(m/^===/) {
      $_="\n";
      $br=0;
      $pagechange=0 if($pagechange>=0);
    }

    if(m/ $/) {
      if((m/\S   $/ && $format==$ODP) ||
	 (m/\S  $/ && $format==$SLA)
	)
      {
	s/ +$//;
      }
      else {
	chop;
	s/ +$/ /;
      }
    }
    if($status>0 && ($status & 0x11)==1) {
      if(m/^[\*#][\*#] \S+ [\*#][\*#]/) {
        ($pagenum)=m/^[\*#][\*#] (\S+) [\*#][\*#]/;
        $fpagenum=$pagenum;
	$fpagenum=~s/^\d+//;
        $fpagenum=sprintf("%02d",$pagenum+0).$fpagenum;
	if($format!=$TXT || $pagenum ne ($pagenum+0)) { $_=""; }
      }
      if($format==$REA) {
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
      }
      if(m/^\t?#/ && $format!=$TXT) {
        $_="";
      }
      if(m/^\[/) {
	($cap,$rest)=m/\[(.*?)\](.*)/s;
	$capfile=$cap;
	if(($c=index($cap,"|"))>0) {
	  $capfile=substr($cap,0,$c);
	  $cap=substr($cap,$c+1);
	}
	$pagecap[$pagenum]=$capfile;
	#print STDERR "PAGECAP $pagenum=$cap ($rest)\n";
	if($format==$TXT || $format==$REA) {
	  $_=$cap.$rest;
        }
	else {
	  $rest=~s/^ +//;
	  $_=$rest;
	}
      }
      if(m/^$/) {
	if($br) {
	  $_="";
	}
	$br++;
      }
      else {
	$br=0;
      }
      print Unformat($_) if($format==$TXT || $format==$REA);
      if($pagenum ne ($pagenum+0)) {
        # Special case
        $pagetext{$fpagenum}.=$_;
      }
      else {
        $pagetext[$pagenum].=$_;
      }
    }
    if(m/^\]\]/) {
      $status&= ~0x10;
      $br=0 if($format!=$REA);
    }
    if($format==$REA && ($status & 0x02)) {
      #$status&=0xFE;
      $status=2;
    }
  }
}
close(F);

# fix text
for($i=0;$i<=$pagenum;$i++) {
  $pnum=sprintf("%02d",$i);
  $pagetext[$i]=RemoveLF($pagetext[$i]);
  if($i>=50 && $i<=55) {
    $pagetext[$i]=~s/^.*?\n\n//s;
  }
  $pagetext{$pnum}=$pagetext[$i];
  @paragraph=();
  $pl="A";
  $n0=0;
  while(($n1=index($pagetext[$i],"\n\n",$n0))>0) {
    $pagetext{"$pnum$pl"}=substr($pagetext[$i],$n0,$n1-$n0);
    $n0=$n1+2;
    $pl++;
  }
  $pagetext{"$pnum$pl"}=substr($pagetext[$i],$n0);
}
# For "special" text boxes (page 2 "Free as in freedom..."
foreach $i (keys %pagetext)
{
  $pagetext{$i}=RemoveLF($pagetext{$i});
}

if($format==$SLA)
{
  $bold="Heebo Bold";
  $italic="Heebo Italic";
  $bolditalic="Heebo Bold Italic";
  if($templatefile=~m/\.gz$/) {
    $err=open(S,"gunzip -c \"$templatefile\"|");
  }
  else {
    $err=open(S,$templatefile);
  }
  if(!$err) {
    print STDERR "Error opening template file $templatefile: $!\n";
    exit(2);
  }
  while(<S>) {
    if(m/<Fonts .*Bold.*Italic/i) {
      ($bolditalic)=m/<Fonts .*Name="(.*?)"/;
    }
    elsif(m/<Fonts .*Bold/i) {
      ($bold)=m/<Fonts .*Name="(.*?)"/;
    }
    elsif(m/<Fonts .*Italic/i) {
      ($italic)=m/<Fonts .*Name="(.*?)"/;
    }
    s/ LANGUAGE="\S+?"/ LANGUAGE="$language"/g;
    if(m/PFILE="Capitals/) {
      # File Capital image
      ($page0)=m/OwnPage="(\d+)"/;
      ($height)=m/HEIGHT="([\d\.]+)"/;
      ($suffix)=m/PFILE="Capitals\/(\S+?)"/;
      if($page0==0) {
	# Back cover
        $page1=60;
      }
      else {
        $page1=$page0+1;
      }
      $file="Capitals/$pagecap[$page1]$suffix";
      s/PFILE="Capitals\/\S+?"/PFILE="$file"/;
      $dim=`file -L $file`;
      ($x,$y)=($dim=~m/, (\d+) x (\d+),/);
      chop($dim);
      #print STDERR "$file $x $y $page1 $pagecap[$page1] ($dim)";
      if($y>0) {
	if($y>317) {
	  # Fix height and position (e.g. for Eacute)
	  $oldheight=$height;
	  $height=sprintf("%.2f",$height*$y/316);
	  ($ypos)=m/YPOS="([\d\.]+)"/;
	  ($gypos)=m/gYpos="([\d\.]+)"/;
	  $ypos-=$height-$oldheight;
	  $gypos-=$height-$oldheight;
	  s/HEIGHT="\S+?"/HEIGHT="$height"/;
	  s/YPOS="\S+?"/YPOS="$ypos"/;
	  s/gYpos="\S+?"/gYpos="$ypos"/;
	  s/(M0 0 L[\d\.]+ 0 L[\d\.]+) [\d\.]+ L0 [\d+\.] L0/$1 $height L0 $height L0/g;
	}
	$width=sprintf("%.4f",$height*$x/$y);
	s/WIDTH="\S+?"/WIDTH="$width"/;
	s/M0 0 L[\d\.]+ 0 L[\d\.]+/M0 0 L$width 0 L$width/g;
      }
    }
    elsif(m/<ITEXT CH="TEXT-PAGE/)
    {
      ($page)=m/<ITEXT CH="TEXT-PAGE(\S+?)"/;
      $_=FormatSLA($pagetext{$page},substr($_,0,index($_,"<")));
    }
    print;
  }
  close(S);
}
