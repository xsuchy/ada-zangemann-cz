#!/usr/bin/perl

# SPDX-FileCopyrightText: 2022-2023 Luca Bonissi
# SPDX-FileCopyrightText: 2024 Nico Rikken
#
# SPDX-License-Identifier: CC0-1.0

# Basic debugging:
# print STDERR "Current page number: $pagenum \n";

$TXT = 0;
$ODP = 1;
$SLA = 2;
$REA = 3;
$EPU = 4;

$format = $TXT;

# Determine output format based on directory structure
if ( $0 =~ /scribus/ ) {
    $format = $SLA;
}
elsif ( $0 =~ /odp/ ) {
    $format = $ODP;
}
elsif ( $0 =~ /reading/ ) {
    $format = $REA;
}
elsif ( $0 =~ /epub/ ) {
    $format = $EPU;
}

$cwd = `pwd`;
chomp($cwd);

$textfile     = shift;
$templatefile = shift;
$templatedir  = shift;

# Print usage information if no input is provided
if (   length($textfile) == 0
    || ( ( $format == $SLA || $format == $ODP ) && length($templatefile) == 0 )
    || ( ( $format == $ODP ) && length($templatedir) == 0 ) )
{
    if ( $format == $SLA ) {
        print STDERR
          "\nUsage: $0 source.txt template.sla > destination.sla\n\n";
    }
    elsif ( $format == $ODP ) {
        print STDERR "\nUsage: $0 source.txt template.odp destination.odp\n\n";
    }
    else {
        print STDERR "\nUsage: $0 source.txt > destination.txt \n\n";
    }
    exit(1);
}

$language = $textfile;
$language =~ s/-source//;
$language =~ s/\.txt//;
if ( $i = rindex( $language, "-" ) ) {
    $language = substr( $language, $i + 1 );
}
else {
    $language = "en";
}

if ( !open( F, $textfile ) ) {
    print STDERR "Error opening $textfile: $!\n";
    exit(1);
}

# Removes inline '\n' line-feeds from the provided string
sub RemoveLF {
    my $pagetext = shift;
    $pagetext =~ s/^\n+//gs;
    while ( length($pagetext) > 0 && substr( $pagetext, -1 ) eq "\n" ) {
        chop($pagetext);
    }
    return ($pagetext);
}

# Removes basic HTML-like formatting from the provided string
sub Unformat {
    my $s = shift;
    $s =~ s|<b>||gis;
    $s =~ s|</b>||gis;
    $s =~ s|<i>||gis;
    $s =~ s|</i>||gis;
    return ($s);
}

# Split the provided XML string into an array. Each '<' character triggers a new array element.
sub SplitXML {
    my $buffer = shift;
    my ( $i, $i2, $i3, @xml );
    $i = -1;
    while ( $i < length($buffer) ) {
        $i2 = index( $buffer, "<", $i + 1 );
        if ( $i2 >= 0 ) {
            if ( $i2 > 0 ) {
                push( @xml, substr( $buffer, $i, $i2 - $i ) );
            }
            $i = $i2;
        }
        else {
            push( @xml, substr( $buffer, $i ) );
            $i = length($buffer);
        }
    }
    return (@xml);
}

# Encodes special characters in HTML-like format for use in XML
sub FormatXML {
    my $s = shift;
    $s =~ s/\&/\&amp;/gs;
    $s =~ s/"/\&quot;/gs;
    $s =~ s/</\&lt;/gs;
    $s =~ s/>/\&gt;/gs;
    return ($s);
}

# Add text formatting to text for Scribus
sub ReplaceFormat {
    my ( $par, $fmt, $font ) = @_;
    my ( $i, $f, $c0, $c1, $c2, $lc, $ofmt, $cfmt );
    $lc = lc($par);

    # Check for formatting marks to replace
    # $fmt expected to be "b", "i", "bi".
    $c0   = 0;
    $ofmt = "<$fmt>";     # open tag
    $cfmt = "</$fmt>";    # close tag
    while ( ( $c1 = index( $lc, $ofmt, $c0 ) ) >= 0 ) {
        if ( $c1 > $c0 ) {
            $f .= substr( $par, $c0, $c1 - $c0 );
        }
        $c1 += length($ofmt);
        $c2 = index( $lc, $cfmt, $c1 );
        if ( $c2 > $c1 ) {
            $f .= "<ITEXT FONT=\"$font\" CH=\""
              . FormatXML( substr( $par, $c1, $c2 - $c1 ) ) . "\"/>";
            $c0 = $c2 + length($cfmt);
        }
        else {
            # Wrong formatting...
            $f .= substr( $par, $c1 );
            $c0 = length($lc);
        }
    }
    if ( $c0 < length($lc) ) {
        $f .= substr( $par, $c0 );
    }
    return ($f);
}

# Format paragraphs for Scribus
sub FormatSLA {
    my $s     = shift;
    my $space = shift;
    my ( @par, $i, $f, $c0, $c1, $c2, $lc, $slocal, $ofmt, $cfmt );
    @par = split( "\n", $s );
    for ( $i = 0 ; $i <= $#par ; $i++ ) {

    # Add Scribus formatting to text to change fonts according to style (b,i,bi)
        $slocal = $par[$i];
        $slocal = ReplaceFormat( $slocal, "b",  $bold );
        $slocal = ReplaceFormat( $slocal, "i",  $italic );
        $slocal = ReplaceFormat( $slocal, "bi", $bolditalic );
        $lc     = $slocal;

        # Place XML tags
        $c0   = 0;
        $ofmt = "<ITEXT ";
        $cfmt = "\"/>";
        while ( ( $c1 = index( $lc, $ofmt, $c0 ) ) >= 0 ) {
            if ( $c1 > $c0 ) {
                $f .=
                    $space
                  . "<ITEXT CH=\""
                  . FormatXML( substr( $slocal, $c0, $c1 - $c0 ) )
                  . "\"/>\n";
            }
            $c2 = index( $lc, $cfmt, $c1 );
            if ( $c2 > $c1 ) {
                $c2 += length($cfmt);
                $f .= $space . substr( $slocal, $c1, $c2 - $c1 ) . "\n";
                $c0 = $c2;
            }
            else {
                # Wrong formatting...
                $f .=
                    $space
                  . "<ITEXT CH=\""
                  . FormatXML( substr( $slocal, $c1 ) )
                  . "\"/>\n";
                $c0 = length($lc);
            }
        }
        if ( $c0 < length($lc) ) {
            $f .=
                $space
              . "<ITEXT CH=\""
              . FormatXML( substr( $slocal, $c0 ) )
              . "\"/>\n";
        }
        if ( $i < $#par ) {
            $f .= $space . "<para/>\n";
        }
    }
    return ($f);
}

# Format text with XML tags for ODP notes
sub FormatODPNotes {
    my $s = shift;
    my ( @par, $i, $f );
    @par = split( "\n", $s );
    for ( $i = 0 ; $i <= $#par ; $i++ ) {
        if ( length( $par[$i] ) == 0 ) {    # empty paragraph
            $f .= "<text:p/>\n";
        }
        else {                              # enclose paragraph in tags
            $f .= "<text:p>" . FormatXML( $par[$i] ) . "</text:p>\n";
        }
    }
    return ($f);
}

$text_pre  = "<text:p text:style-name=\"P6\">";
$span_pre  = "<text:span text:style-name=\"T2\">";
$text_post = "</text:p>";
$span_post = "</text:span>";

# Format the last ODP page to handle the link
sub FormatODPLast {
    my $s = shift;
    my ( @par, $i, $f, $pre, $post, $link );
    @par = split( "\n", $s );
    for ( $i = 0 ; $i <= $#par ; $i++ ) {
        if ( $par[$i] =~ m/https:/ ) {

            # Split the link and format the rest
            ( $pre, $link, $post ) = ( $par[$i] =~ m|^(.*)(https:\S+)(.*)| );
            $f .= $text_pre;
            if ( length($pre) > 0 ) {
                $f .= $span_pre . FormatXML($pre) . $span_post;
            }
            $f .=
                $span_pre
              . "<text:a xlink:href=\"$link\" xlink:type=\"simple\">$link</text:a>"
              . $span_post;
            if ( length($post) > 0 ) {
                $f .= $span_pre . FormatXML($post) . $span_post;
            }
            $f .= $text_post;
        }
        else {
            $f .=
                $text_pre
              . $span_pre
              . FormatXML( $par[$i] )
              . $span_post
              . $text_post;
        }
    }
    return ($f);
}

$status     = -1;
$pagechange = 0;
$br         = 0;
$pagenum    = 0;
$slidenum   = 0;
while (<F>) {
    if ( $status == -1 ) {
        if (m/^#/) {
            print if ( $format == $TXT || $format == $REA );
            $_ = "";
        }
        else {
            if ( $format == $REA ) {
                $status = 0;
            }
            else {
                $status = 1;
            }
        }
    }
    else {
        if (m/^\[\[/) {
            $status |= 0x10;
        }
        if ( $format == $REA || $format == $ODP ) {
            if (m/^=== /) {
                $status     = 1;
                $pagechange = 0 if ( $pagechange >= 0 );
            }
            elsif (m/^=====/) {
                $status = 3 if ( $format == $REA );
            }
        }
        elsif (m/^===/) {
            $_          = "\n";
            $br         = 0;
            $pagechange = 0 if ( $pagechange >= 0 );
        }

        # Handle input format line endings to continuation or hard line breaks.
        if (m/ $/) {
            if (   ( m/\S   $/ && $format == $ODP )
                || ( m/\S  $/ && $format == $SLA ) )
            {
                s/ +$//;    # Remove trailing spaces.
            }
            else {
                chop;        # Remove one character (newline) to combine lines.
                s/ +$/ /;    # Replace all trailing spaces with a single space.
            }
        }
        if ( $status > 0 && ( $status & 0x11 ) == 1 ) {

            # Find page number separator and set variables accordingly
            if (m/^[\*#][\*#] \S+ [\*#][\*#]/) {
                ($pagenum) = m/^[\*#][\*#] (\S+) [\*#][\*#]/;
                $fpagenum = $pagenum;
                $fpagenum =~ s/^\d+//;
                $fpagenum = sprintf( "%02d", $pagenum + 0 ) . $fpagenum;
                if ( $format != $TXT || $pagenum ne ( $pagenum + 0 ) ) {
                    $_ = "";
                }
            }

            # Handle slide transitions
            if ( $format == $REA || $format == $ODP ) {
                if (m/^===/) {
                    if ( $pagechange >= 0 ) {
                        $pagechange = 1;
                    }
                    else {
                        if ( $format == $REA ) {
                            if ( !$br ) { print "\n"; }
                            print "\n";
                        }
                        $br = 1;
                        $_  = "";
                    }
                }
                if ( $pagechange > 0 ) {
                    ($slide) = m/= (.*)/;
                    if ( length($slide) > 0 ) {
                        $slide = "($slide)";
                    }
                    if ( $format == $REA ) {
                        if ( !$br ) {
                            print "\n";
                        }
                        print "<!-- Change Page $slide -->\n"
                          if ( !$templatefile );
                        print "\n";
                    }
                    if ( $slide =~ m/\d+/ ) {
                        ($slidenum) = ( $slide =~ m/(\d+)/ );
                    }

                    #print STDERR "SLIDENUM $slide $slidenum\n";
                    else {
                        $slidenum++;
                    }
                    if ( $slidenum >= 26 ) {
                        $slidenum = 0;
                    }
                    $_          = "";
                    $br         = 1;
                    $pagechange = 0;
                }
            }
            if ( m/^\t?#/ && $format != $TXT ) {
                $_ = "";
            }

            # Handle capital letters
            if (m/^\[/) {
                ( $cap, $rest ) = m/\[(.*?)\](.*)/s;
                $capfile = $cap;
                if ( ( $c = index( $cap, "|" ) ) > 0 ) {
                    $capfile = substr( $cap, 0, $c );
                    $cap     = substr( $cap, $c + 1 );
                }
                $pagecap[$pagenum] = $capfile;

                #print STDERR "PAGECAP $pagenum=$cap ($rest)\n";
                if ( $format == $TXT || $format == $REA || $format == $ODP ) {
                    $_ = $cap . $rest;
                }
                else {
                    $rest =~ s/^ +//;
                    $_ = $rest;
                }
            }
            if (m/^$/) {
                if ($br) {
                    $_ = "";
                }
                $br++;
            }
            else {
                $br = 0;
            }
            print Unformat($_) if ( $format == $TXT || $format == $REA );
            if ( $pagenum ne ( $pagenum + 0 ) ) {

                # Special case
                $pagetext{$fpagenum} .= $_;
            }
            else {
                $pagetext[$pagenum] .= $_;
            }
            if ( $slidenum > 0 ) {
                $slide[$slidenum] .= Unformat($_);
            }
        }
        if (m/^\]\]/) {
            $status &= ~0x10;
            $br = 0 if ( $format != $REA );
        }
        if ( $format == $REA && ( $status & 0x02 ) ) {

            #$status&=0xFE;
            $status = 2;
        }
    }
}
close(F);

# fix text
for ( $i = 0 ; $i <= $pagenum ; $i++ ) {
    $pnum = sprintf( "%02d", $i );
    $pagetext[$i] = RemoveLF( $pagetext[$i] );
    if ( $i >= 50 && $i <= 55 ) {
        $pagetext[$i] =~ s/^.*?\n\n//s;
    }
    $pagetext{$pnum} = $pagetext[$i];
    @paragraph       = ();
    $pl              = "A";
    $n0              = 0;
    while ( ( $n1 = index( $pagetext[$i], "\n\n", $n0 ) ) > 0 ) {
        $pagetext{"$pnum$pl"} = substr( $pagetext[$i], $n0, $n1 - $n0 );
        $n0 = $n1 + 2;
        $pl++;
    }
    $pagetext{"$pnum$pl"} = substr( $pagetext[$i], $n0 );
}

# For "special" text boxes (page 2 "Free as in freedom...)"
foreach $i ( keys %pagetext ) {
    $pagetext{$i} = RemoveLF( $pagetext{$i} );
}

for ( $i = 1 ; $i <= $slidenum ; $i++ ) {
    $slide[$i] = RemoveLF( $slide[$i] );
}

if ( $format == $SLA ) {    # Scribus template

    # Start with default fonts
    $bold       = "Heebo Bold";
    $italic     = "Heebo Italic";
    $bolditalic = "Heebo Bold Italic";

    # Open file
    if ( $templatefile =~ m/\.gz$/ ) {
        $err = open( S, "gunzip -c \"$templatefile\"|" );
    }
    else {
        $err = open( S, $templatefile );
    }
    if ( !$err ) {
        print STDERR "Error opening template file $templatefile: $!\n";
        exit(2);
    }
    while (<S>) {

        # Set font variables according to template
        if (m/<Fonts .*Bold.*Italic/i) {
            ($bolditalic) = m/<Fonts .*Name="(.*?)"/;
        }
        elsif (m/<Fonts .*Bold/i) {
            ($bold) = m/<Fonts .*Name="(.*?)"/;
        }
        elsif (m/<Fonts .*Italic/i) {
            ($italic) = m/<Fonts .*Name="(.*?)"/;
        }

        # Set language in Scribus template
        s/ LANGUAGE="\S+?"/ LANGUAGE="$language"/g;
        if (m/PFILE="Capitals/) {

            # Determine filepath of Capital image
            ($page0)  = m/OwnPage="(\d+)"/;
            ($height) = m/HEIGHT="([\d\.]+)"/;
            ($suffix) = m/PFILE="Capitals\/(\S+?)"/;
            if ( $page0 == 0 ) {

                # Back cover
                $page1 = 60;
            }
            else {
                $page1 = $page0 + 1;
            }
            $file = "Capitals/$pagecap[$page1]$suffix";
            s/PFILE="Capitals\/\S+?"/PFILE="$file"/;

            # Get Capital file dimensions into $x and $y
            $dim = `file -L $file`;
            ( $x, $y ) = ( $dim =~ m/, (\d+) x (\d+),/ );
            chop($dim);

            #print STDERR "$file $x $y $page1 $pagecap[$page1] ($dim)";
            if ( $y > 0 ) {
                if ( $y > 317 ) {

                    # Fix height and position (e.g. for Eacute)
                    $oldheight = $height;
                    $height    = sprintf( "%.2f", $height * $y / 316 );
                    ($ypos)  = m/YPOS="([\d\.]+)"/;
                    ($gypos) = m/gYpos="([\d\.]+)"/;
                    $ypos  -= $height - $oldheight;
                    $gypos -= $height - $oldheight;
                    s/HEIGHT="\S+?"/HEIGHT="$height"/;
                    s/YPOS="\S+?"/YPOS="$ypos"/;
                    s/gYpos="\S+?"/gYpos="$ypos"/;
s/(M0 0 L[\d\.]+ 0 L[\d\.]+) [\d\.]+ L0 [\d+\.] L0/$1 $height L0 $height L0/g;
                }
                $width = sprintf( "%.4f", $height * $x / $y );
                s/WIDTH="\S+?"/WIDTH="$width"/;
                s/M0 0 L[\d\.]+ 0 L[\d\.]+/M0 0 L$width 0 L$width/g;
            }
        }
        elsif (m/<ITEXT CH="TEXT-PAGE/) {
            ($page) = m/<ITEXT CH="TEXT-PAGE(\S+?)"/;
            $_ =
              FormatSLA( $pagetext{$page}, substr( $_, 0, index( $_, "<" ) ) );
        }
        print;
    }
    close(S);
}
elsif ( $format == $ODP ) {    # Presentation
    if ( !( $templatefile =~ m|^/| ) ) {
        $templatefile = "$cwd/$templatefile";
    }
    if ( !( $templatedir =~ m|^/| ) ) {
        $templatedir = "$cwd/$templatedir";
    }
    if ( !-f $templatefile ) {
        print STDERR
          "Template file ($templatefile) does not exists. Aborting.\n";
        exit(2);
    }
    if ( length( $ENV{TMP} ) == 0 ) { $ENV{TMP} = "/tmp"; }
    $tmpdir = "$ENV{TMP}/odp_$$";
    if ( !mkdir($tmpdir) ) {
        print STDERR "Cannot create temporary directory: $!\n";
        exit(3);
    }

    # Unzip ODP template file into a directory for editing
    system("cd '$tmpdir'; unzip $templatefile");

    # Opening template content file:
    if ( !open( T, "$tmpdir/content.xml" ) ) {
        print STDERR
"Could not open 'content.xml' file from template.\nPlease check that the template file is readeable\nand it is an OpenDocument Presentation zip file\n";
        system("rm -rf $tmpdir");
        exit(4);
    }
    $buffer = "";
    while (<T>) {
        $buffer .= $_;
    }
    close(T);

    # Split XML elements:
    @xml      = SplitXML($buffer);
    $status   = 0;
    $slidenum = 0;
    $out      = "";
    for ( $i = 0 ; $i <= $#xml ; $i++ ) {
        $xml = $xml[$i];
        if ( $status == 0 && $xml =~ m|^<draw:page| ) {
            $status = 1;
            ($slide) = ( $xml =~ m|draw:name="page(\d+)"|s );
            if ( $slide == 0 ) {
                $slidenum++;
                $slide = $slidenum;
            }
            else {
                $slidenum = $slide + 0;
            }
            if ( $slide == 26 ) {

                # Special case, license text
                $status = 26;
            }
        }
        elsif ( $xml =~ m|^<presentation:notes| ) {
            $status = 2;

            #print STDERR "NOTES $slide...\n";
        }
        elsif ( $status == 2 && $xml =~ m|^<draw:text-box| ) {

            #print STDERR "DRAWBOX $slide...\n";
            if ( length( $slide[$slide] ) > 0 ) {
                $xml .= FormatODPNotes( $slide[$slide] );
                $status = 3;
            }
        }
        elsif ( $status == 3 && $xml =~ m|^</draw:text-box| ) {
            $status = 2;
        }
        elsif ( $status == 3 && $xml =~ m|^</?text:| ) {
            $xml = "";
        }
        elsif ( $status == 26 && $xml =~ m|^<text:p text:style-name="P6"| ) {
            $status = 27;
            $xml    = FormatODPLast( Unformat( $pagetext[55] ) );
        }
        elsif ( $status == 27 && $xml =~ m|</?text:| ) {
            $xml = "";
        }
        elsif ( $xml =~ m|^</presentation:notes| ) {
            $status = 1;
        }
        elsif ( $status == 27 && $xml =~ m|^</draw:text-box| ) {
            $status = 1;
        }
        elsif ( $status == 1 && $xml =~ m|^</draw:page| ) {
            $status = 0;
        }
        $out .= $xml;

        #print STDERR "$status) ".substr($xml,0,40)."...\n";
    }
    if ( !open( T, ">$tmpdir/content.xml" ) ) {
        print STDERR "Cannot open file 'content.xml' for writing: $!\n";
        system("rm -rf $tmpdir");
        exit(5);
    }
    print T $out;
    close(T);

    #$out=~s|<|\n<|gs;
    #print $out;
    system("cd '$tmpdir'; zip -9 -r $templatedir *");
    system("rm -rf $tmpdir");
}
