#!/bin/bash
#    remove supercmd from PATH
#
#    Author: Steve Göring

#    This file is part of supercmd.
#
#    supercmd is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    supercmd is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with supercmd.  If not, see <http://www.gnu.org/licenses/>.

#
#    Load libaries and toolkits.
#
scriptPath=${0%/*}
. "$scriptPath"/../../libs/bashhelper.sh
. "$scriptPath"/../../libs/shflags

check_tools "unlink"

#
#    Define usage screen.
#
usage() {
    echo "
Usage:
    $(basename "$0") [flags]

Description:
    Removes supercmd from PATH.

Examples:
    $(basename "$0")

Authors:
    Steve Göring"
    exit 1
}

#
#    Define command line arguments and parse them.
#
FLAGS_HELP=$(usage)
export FLAGS_HELP
FLAGS "$@" || exit 1  # Parse command line arguments.
eval set -- "${FLAGS_ARGV}"

#
#
#
main() {
    logInfo "Remove supercmd from path."
    logWarn "Sudo required."

    if [ -L "/usr/bin/supercmd" ]; then
        sudo unlink "/usr/bin/supercmd"
    fi

}

#
#    Start programm with parameters.
#
main "$@"