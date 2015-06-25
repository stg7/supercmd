#!/bin/bash
#    check codestyle of project
#
#    Codestyle checker
#
#    Project SuperCMD
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

check_tools "pep8 readlink"

errors=0
files=0

checkResult() {
    if [ "$?" != "0" ]; then
        logError "$2 .. fail"
        echo "$1"
        errors=$((errors + 1))
    fi
    files=$((files + 1))
}

CheckCodeConvetions() {
    # code conventions
    logInfo "check code conventions"
    project_path=$(readlink -f -- "$scriptPath"/../../)
    for i in $(find $project_path -name "*.py" | grep -v "pssh")
    do
        # ignore just this stupid 80 char long lines rule
        output=$(pep8 --ignore=E501 "$i")
        checkResult "$output" "$i"
    done

    for i in $(find $project_path -name "*.sh")
    do
        # ignore just this stupid 80 char long lines rule
        output=$("$project_path/libs/bashconventions" "$i")
        checkResult "$output" "$i"
    done

    logInfo "$errors of $files unvalid files."
}

#
#    Define usage screen.
#
usage() {
    echo "
Usage:
    $(basename "$0")

Description:
    Check code conventions of toolkit.

Examples:
    $(basename "$0")
"
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
#    Check Code conventions of python and bash scripts.
#
main() {

    CheckCodeConvetions
}

#
#    Start programm with parameters.
#
main "$@"