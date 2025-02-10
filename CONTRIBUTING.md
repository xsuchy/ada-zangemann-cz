<!--
SPDX-FileCopyrightText: 2024 Nico Rikken <nico.rikken@fsfe.org>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Contributing to Ada-Zangemann repository and automation

_This document is intended as help for technical contributions. See [translation
guidelines](Translation-Guidelines.md) for documentation on contributing
translations._

## Git access

This repository is hosted on the Git infrastructure of the FSFE. It requires an
account to create a merge request or contribute to the discussions.

The easiest path to access is to [become an FSFE
Supporter](https://my.fsfe.org/donate) as Supporters get an account on the
infrastructure. Your financial contribution will strengthen the solid foundation
on which we are building our charitable work for freedom in the information
society.

Alternatively you can reach out to the FSFE with your contribution. We will work
with you to get the contributions merged. Whether this is a file attached to an
email or an external git repository from which commits can be picked.

## Formatting

Formatting guidelines are a work in progress. The general aim is for code to be
and stay readable by having consistent formatting that can be applied applied
using automated tools.

**Perl** files can be formatted using
[perltidy](https://metacpan.org/dist/Perl-Tidy/view/bin/perltidy) available in
most package repositories.

## Pre-commit checks

A configuration is available for the pre-commit framework. See the installation
guide on the [pre-commit website](https://pre-commit.com/).

Typically the checks are run every git commit. The automatic checks can be
ignored uign the `--no-verify` flag on the git commit command.
