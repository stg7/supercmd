#!/usr/bin/env python3
#   easter egg
"""
    Easter egg

    Copyright 2015-today

    Author: Steve Göring
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

import os
import sys
import inspect
import time
import shutil

script_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
sys.path.insert(0, os.path.abspath(os.path.join(script_dir, "..", "..", "libs")))

from log import *


def main(params):

    max_i = shutil.get_terminal_size().columns
    for j in range(3):
        for i in range(0, max_i):
            if i % 2 == 0:
                print(" " * i + colorred("ᗧ") + "•" * (max_i - i - 1), end='\r')
            else:
                print(" " * i + colorgreen("◯") + "•" * (max_i - i - 1), end='\r')
            time.sleep(0.15)

        for i in reversed(range(0, max_i)):
            if i % 2 == 0:
                print("•" * i + colorred("ᗤ") + " " * (max_i - i - 1), end='\r')
            else:
                print("•" * i + colorgreen("◯") + " " * (max_i - i - 1), end='\r')
            time.sleep(0.15)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
