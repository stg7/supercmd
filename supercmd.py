#!/usr/bin/env python3
"""
    SuperCMD

    author: Steve Göring
    contact: stg7@gmx.de

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

import sys
import os
import argparse
import json

import loader

from log import *
from lib import *
from system import *


def get_modules(config):
    """
    read all modules from moduls_directory
    :return list of modules
    """
    lInfo("read all available moduls in " + config["moduls_directory"])
    modules = {}
    for directory in os.listdir(config["moduls_directory"]):
        if os.path.isdir(config["moduls_directory"] + directory) and directory not in config["ignored_dirs"]:
            modules[directory] = config["moduls_directory"] + directory
    return modules


def check_allowed_shebang(scriptpath, allowed_scripts):
    """
    check for given script if it is allowed
    :return true if scriptpath has a valid shebang
    """
    shebang = get_shebang(scriptpath)
    for interpreter in allowed_scripts:
        if interpreter in shebang:
            return True
    return False


def get_submodules(config, modulepath):
    """
    get all submodules based on modulepath
    :return list of submodules
    """
    submodules = {}
    for script in os.listdir(modulepath):
        scriptpath = modulepath + "/" + script
        if os.path.isfile(scriptpath):
            if check_allowed_shebang(scriptpath, config["allowed_scripts"]):
                # store scriptname without extension as shortcut
                submodules[script.rsplit(".", 1)[0]] = scriptpath

    return submodules


def get_submodule_description(modulepath):
    """
    extract submodul description based on modulepath
    :return description
    """
    if not os.path.isfile(modulepath):
        return os.path.basename(modulepath)

    f = open(modulepath)
    lines = f.readlines()
    f.close()
    if len(lines) < 1 or lines[1][0] != "#":
        return ""
    return lines[1][1:].replace("\n", "").strip()


def handle_script(submodul, scriptfile, params=[]):
    """
    run extracted submodul based on scriptpath with all given params as parameter
    :return exit code of submodul
    """
    lInfo("start script")
    lDbg("run: " + submodul + ", path: " + scriptfile)

    lInfo("output:")
    cmd = " ".join([scriptfile] + params)

    # make script executable
    os.system("chmod +x {}".format(scriptfile))
    return_value = os.system(cmd)

    if return_value == 0:
        lInfo("done")
    else:
        lError("something was wrong with your call: " + cmd)

    return return_value


def get_keys_startswith(dictionary, searchkey):
    """
    extract keys that have a prefix match
    """
    needed_keys = [x for x in dictionary.keys() if x.startswith(searchkey)]
    return needed_keys


def main(args):
    lInfo("read config")
    # read config file
    try:
        config = json.loads(read_file(os.path.dirname(os.path.realpath(__file__)) + "/config.json"))
    except Exception as e:
        lError("configuration file 'config.json' is corupt (not json conform).")
        return 1

    # config check
    if not os.path.isdir(config["moduls_directory"]):
        config["moduls_directory"] = os.path.dirname(os.path.realpath(__file__)) + "/" + config["moduls_directory"]
        if not os.path.isdir(config["moduls_directory"]):
            lError("moduls_directory " + config["moduls_directory"] + " is not a valid directory, check config.json")
            return 1

    modules = get_modules(config)

    parser = argparse.ArgumentParser(description='supercmd -- meta cmd controller', epilog="Steve Göring 2015", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('modul', type=str, choices=list(modules.keys()), help='modulname')
    parser.add_argument('submodul', type=str, nargs='?', default="help", help='submodul')
    parser.add_argument('parameter', type=str, nargs='*', help='parameters for submodul command')

    if len(args) > 0 and len(get_keys_startswith(modules, args[0])) == 1:
        args[0] = get_keys_startswith(modules, args[0])[0]

    argsdict = vars(parser.parse_args(args[0:2]))  # using args[..] is necessary because of unknown arguments in the parameters for submoduls

    # set parameters
    argsdict["parameter"] = args[2:]

    lInfo("available moduls: " + str(len(modules)))

    if argsdict["modul"] not in modules:
        lError("selected modul " + argsdict["modul"] + " is not available, " + str(list(modules.keys())))
        return 1
    lInfo("selected modul: " + argsdict["modul"])

    submodules = get_submodules(config, modules[argsdict["modul"]])
    submodules["help"] = "integrated help"

    if len(get_keys_startswith(submodules, argsdict["submodul"])) == 1:
        argsdict["submodul"] = get_keys_startswith(submodules, argsdict["submodul"])[0]

    if argsdict["submodul"] == "help":
        lHelp("submodules of " + argsdict["modul"])
        max_size = len(max(submodules.keys(), key=len))
        format_str = "{:<" + str(max_size) + "}"
        for sub in sorted(submodules.keys()):
            lHelp("    " + format_str.format(sub) + " : " + get_submodule_description(submodules[sub]))
        return 0

    if argsdict["submodul"] not in submodules:
        lError("selected submodul " + argsdict["submodul"] + " is not available use help, " + str(list(submodules.keys())))
        return 1

    lInfo("selected submodul: " + argsdict["submodul"])
    return handle_script(argsdict["submodul"], submodules[argsdict["submodul"]], argsdict["parameter"])


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
