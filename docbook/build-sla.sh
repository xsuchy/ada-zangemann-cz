#!/bin/bash

# SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>
#
# SPDX-License-Identifier: CC0-1.0

# Convenient script during development to generate various outputs and print
# log for deubgging

rm Ada_Zangemann-en-print-all.sla{,.log}
rm Ada_Zangemann-en-print-img.sla{,.log}
rm Ada_Zangemann-en-print-text.sla{,.log}
make Ada_Zangemann-en-print-all.sla > Ada_Zangemann-en-print-all.sla.log 2>&1
make Ada_Zangemann-en-print-img.sla > Ada_Zangemann-en-print-img.sla.log 2>&1
make Ada_Zangemann-en-print-text.sla > Ada_Zangemann-en-print-text.sla.log 2>&1
less Ada_Zangemann-en-print-img.sla.log
# less Ada_Zangemann-en-print.sla
xmllint --format Ada_Zangemann-en-print-img.sla | less
