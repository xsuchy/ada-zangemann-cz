#!/usr/bin/perl

# SPDX-FileCopyrightText: 2022-2023 Luca Bonissi
#
# SPDX-License-Identifier: CC0-1.0

use utf8;

$wrap                  = 72;
$max_wrap_manual_break = 110;
$remove_space          = 0;

sub Wrap {
    my ( $line, $wrap, $maxlen ) = @_;
    my ( $i, $ch, $s );

    if ( $maxlen == 0 ) { $maxlen = $wrap + 1; }

    $s = "";

    while ( length($line) > $maxlen ) {
        $i  = $wrap;
        $ch = substr( $line, $i, 1 );
        while ( $i >= 0 && $ch ne " " && $ch ne chr(9) ) {
            $i--;
            $ch = substr( $line, $i, 1 );
        }

        # Check if we have extra space forward:
        while ( $i < length($line) && $ch eq " " ) {
            $ch = substr( $line, $i + 1, 1 );
            if ( $ch eq " " ) { $i++; }
        }
        if ( $i >= 0 ) {
            $i++;
            $s .= substr( $line, 0, $i - $remove_space ) . "\n";
            $line = substr( $line, $i );
            if ( $line eq "\n" ) { $line = ""; }
        }
        else {
            $s .= substr( $line, 0, $wrap ) . "\n";
            $line = substr( $line, $wrap );
        }
    }
    $s .= $line;
    return ($s);
}

$s    = STDIN;
$file = shift;
if ( length($file) > 0 ) {
    if ( !open( $s, "$file" ) ) {
        print STDERR "Cannot open file $file: $!\n";
        exit(1);
    }
}
binmode( $s,     ":utf8" );
binmode( STDOUT, ":utf8" );
while ( $line = <$s> ) {
    if ( $line =~ m/^\s*#/ ) {
        print $line;
    }
    elsif ( substr( $line, -3 ) eq "  \n" ) {

        # Special handling - Ada forced break
        if ( length($line) > $max_wrap_manual_break ) {

            # Calculate the optmimal number of lines:
            #$nl=int(length($line)/$wrap)+1;
            #print Wrap($line,int(length($line)/$nl)+2,$wrap+10);
            print Wrap( $line, $wrap, $wrap + 5 );
        }
        else {
            print $line;
        }
    }
    else {
        print Wrap( $line, $wrap );
    }
}
