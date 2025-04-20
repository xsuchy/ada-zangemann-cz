#!/usr/bin/perl

# SPDX-FileCopyrightText: 2022-2023 Luca Bonissi
#
# SPDX-License-Identifier: CC0-1.0

use utf8;

$wrap                  = 72;
$max_wrap_manual_break = 110;
$remove_space          = 0;

# Function to wrap a single line
sub Wrap {

    # Take input parameters to override default settings
    my ( $line, $wrap, $maxlen ) = @_;

    # Use variables:
    # $i  for character index
    # $ch for character at index
    # $s  for wrapped lines output
    my ( $i, $ch, $s );

    # If not provided, set a good default for $maxlen
    if ( $maxlen == 0 ) {
        $maxlen = $wrap + 1;
    }

    # Initialise empty output to append lines too
    $s = "";

    # While $line is still too long
    while ( length($line) > $maxlen ) {

        # Start from the back
        $i = $wrap;

        # Read character at index
        $ch = substr( $line, $i, 1 );

        # While character is not a space or tab
        while ( $i >= 0 && $ch ne " " && $ch ne chr(9) ) {

            # Go one step further to the beginning
            $i--;
            $ch = substr( $line, $i, 1 );
        }

        # Check if we have extra space forward, then increase index
        while ( $i < length($line) && $ch eq " " ) {
            $ch = substr( $line, $i + 1, 1 );
            if ( $ch eq " " ) {
                $i++;
            }
        }

        # Split line at index, appending wrapped line to $s
        if ( $i >= 0 ) {
            $i++;

       # Take line substring until index, add line break and append to $s
       # Optionally remove a number of trailing spaces, if provided as parameter
            $s .= substr( $line, 0, $i - $remove_space ) . "\n";

            # Store remaining part in $line
            $line = substr( $line, $i );

            # If remaining part is just a newline, remove it
            if ( $line eq "\n" ) {
                $line = "";
            }
        }

# Search for space ended up at the beginning, just wrap at the wrap length character
        else {
            $s .= substr( $line, 0, $wrap ) . "\n";
            $line = substr( $line, $wrap );
        }
    }

    # Append the last line to $s
    $s .= $line;

    # Return $s containing the wrapped lines
    return ($s);
}

$s    = STDIN;
$file = shift;

# Error to the user if file cannot be read
if ( length($file) > 0 ) {
    if ( !open( $s, "$file" ) ) {
        print STDERR "Cannot open file $file: $!\n";
        exit(1);
    }
}
binmode( $s,     ":utf8" );
binmode( STDOUT, ":utf8" );

# Read input line by line
while ( $line = <$s> ) {

    # No wrapping of lines with comments or banner texts
    if ( $line =~ m/^\s*#/ ) {
        print $line;
    }

    # In case of explicit line break, allow a few characters more
    elsif ( substr( $line, -3 ) eq "  \n" ) {

        # Special handling - Ada forced break, way too long
        if ( length($line) > $max_wrap_manual_break ) {

            # Allow line to be a little bit longer
            print Wrap( $line, $wrap, $wrap + 5 );
        }
        else {
            # Line is good enough, just print
            print $line;
        }
    }
    else {
        # No special situation, just wrap the line
        print Wrap( $line, $wrap );
    }
}
