#!/bin/bash

# SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

# Uncomment to help debugging this script
# set -o xtrace

cd "$(dirname "${0}")"  # Operate in the directory with transparent capitals

if ! [[ -x "$(command -v convert)" ]] ; then
    echo "Ensure that ImageMagick is installed so the 'convert' command is available."
    exit 1
fi

if [[ -z ${1} ]] || [[ -n ${3} ]] ; then
    echo "Provide the png filename that needs to be created." >&2
    echo "Usage:   ./new-color.sh [base-character]-[color-name].png" >&2
    echo "Example: ./new-color.sh A-red2.png" >&2
    exit 1
fi

filename_pattern='^([a-zA-Z]+)-([a-z0-9]+)\.png$'

if [[ ${1} =~ $filename_pattern ]] ; then
    dest_filename="${1}"
    capital="${BASH_REMATCH[1]}"
    color="${BASH_REMATCH[2]}"
else
    echo "Filename didn't match expected pattern." >&2
    exit 1
fi

src_filename="$(ls -t "${capital}"-*.png | tail -n 1)" # Oldest file for this capital

if [[ -z ${src_filename} ]] ; then
    echo "Couldn't find the base character, ensure it is present in this directory" >&2
    exit 1
fi

case ${color} in
    brown    ) hexcolor="#b79b55";;
    cyan     ) hexcolor="#5cb2d4";;
    fucsia   ) hexcolor="#d70071";;
    green    ) hexcolor="#6cba81";;
    lightcyan) hexcolor="#93ccd3";;
    olive    ) hexcolor="#bcc85a";;
    pink     ) hexcolor="#f5b6cd";;
    red1     ) hexcolor="#e75156";;
    red2     ) hexcolor="#e64f55";;
    red3     ) hexcolor="#e74c5b";;
    violet   ) hexcolor="#81579a";;
    yellow   ) hexcolor="#f8d66a";;
esac

if [[ -z ${hexcolor} ]] ; then
    echo "Unable to match color to known colors." >&2
    exit 1
fi

convert -fill "${hexcolor}" -colorize 100,100,100 "${src_filename}" "${dest_filename}"

src_license="${src_filename}.license"

if ! [[ -f ${src_license} ]] ; then
    echo "Couldn't copy '.license' file because source file doesn't have one." >&2
    echo "Please ensure the source file and newly created file include copyright and license information." >&2
    exit 0
else
    cp "${src_license}" "${dest_filename}.license"
fi
