# ini.class.sh

Bash script to be sourced for read access of ini files.

Author: Axel Hahn
License: GNU GPL 3.0

## Installation

Copy ini.class.sh somewhere into your bash project

## Usage

- Source the file `. ini.class.sh || exit 1`

### Get values directly

Get a value from ini file using ini.value with 3 parameters:

* filename of ini file
* section
* key

```shell
server=$( ini.value "/path/to/initfile" "database" "server" )"
echo "Server is $server"
```

### Short way to get values:

**Remark**: Using the short variant can result in unwanted behaviuor when jumping between different ini files using the shorten syntax for all. It is just bash :-)

If you read multiple values from the same section, you can use set file and maybe section too.

`ini.set /path/to/initfile`

Get a value from ini file using ini.value with 2 parameters:

* section
* key

OR

`ini.set /path/to/initfile <section>` to shorten the access with the key only.

Example:

```shell

ini.set /path/to/initfile
ini.setsection database

# it can be combined too
# ini.set /path/to/initfile database

# and then you can access of the pre defined file and action
ini.value "server"

# or access another sction
ini.value "othersection" "varname"
```

## Other functions

### Get section names

`ini.sections "<inifile>"`

It returns a list of all section names without brackets.

```txt
genral
database
...
```

### Get a section

`ini.sections "<inifile>" <section>`

returns the subset from inifile with the given section name.

```txt
key1 = "value 1"
key2 = "value 2"
...
```
