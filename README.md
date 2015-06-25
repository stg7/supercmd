SuperCMD
========
[TOC]

author:
> Steve Göring stg7@gmx.de

About
-----

supercmd is a command wrapping toolkit

Requirements
------------
python3, pep8

Usage
-----
for first starts run:
> $./supercmd.py -h


Configuration
-------------
see: config.json
```
    {
        "moduls_directory": "tools/",
        "allowed_scripts": ["python", "bash"],
        "ignored_dirs": ["CVS"]
    }
```

Modules directory (tools)
-------------------------
e.g.:
├── core
│   ├── checker.sh
│   ├── install.sh
│   └── remove.sh
└── test
    ├── a.sh
    ├── b
    ├── t.oy
    └── t.txt

core and test are metanames for each toolkit
a call
>$./supercmd.py core help

will print a short summary of all tools

>$./supercmd.py core checker

will perform a code style check of the tools directory

Adding a new Module
-------------------
first create a new folder in the "moduls_directory" with name FOLDER
add all scrips to this folder, e.g. MYSCRIPT.py

check if
>$./supercmd.py FOLDER MYSCRIPT
works

### Notes for MYSCRIPT
inside a new module directory, every script should have a small description comment
e.g.:
```
#!/bin/bash
#    NICE DESCRIPTION
ls /
```
it is important for the './supercmd.py NAME help' call that this comment is the second line of the script, this approach can be seen as a extension of shebang

### Bash scripts
use bashhelper functions (logError, ...) for output (see install for including)

### Python scripts
use lib, log, system in "lib" directory for uniform outputs and reducing reinventing the wheel

Possible problems with new modules
----------------------------------
* using of hard coded paths, see core/install.sh for path handling
* using of local imported files, remember supercmd will not change to the working directory of the script, a call will start from supercmd root
* dont create a help.{py,sh} script inside a module

