#!/usr/bin/env python3
# coding=utf-8
"""
    Logging

    small colored logging functions for python

    author: Steve Göring
    contact: stg7@gmx.de
    2015
"""
"""
    This file is part of supercmd.

    supercmd is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    supercmd is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with supercmd.  If not, see <http://www.gnu.org/licenses/>.
"""

def colorred(m):
    return "\033[91m" + m + "\033[0m"


def colorblue(m):
    return "\033[94m" + m + "\033[0m"


def colorgreen(m):
    return "\033[92m" + m + "\033[0m"


def colorcyan(m):
    return "\033[96m" + m + "\033[0m"


def lInfo(msg):
    print(colorgreen("[INFO ] ") + str(msg))


def lError(msg):
    print(colorred("[ERROR] ") + str(msg))


def lDbg(msg):
    print(colorblue("[DEBUG] ") + str(msg))


def lWarn(msg):
    print(colorcyan("[WARN ] ") + str(msg))


def lHelp(msg):
    print(colorblue("[HELP ] ") + str(msg))

if __name__ == "__main__":
    lError("lib is not a standalone module")
    exit(-1)
