## Usage

### Source the script

You need to source the `ini.class.sh` file in your script.
```bash
cd $( dirname $0 )
. vendor/ini.class.sh || exit 1
```

With `ini.help` you get a help with the basic functions.

### Get values directly

This is the maybe most used feature: give me a value from an ini file in a given section.

```shell
ini.value "<inifile>" "<section>" "<key>"
```

Get a value from ini file using ini.value with 3 parameters:

* filename of ini file
* name of the section to read
* key / variable in the given section

**Example** 

If our ini file named `settings.ini`looks like this:

```ini
[general]
...

[database]
server = localhost
port = 3306
...
```

Bash:

```shell
server=$( ini.value "settings.ini" "database" "server" )
echo "Server is $server" # "Server is localhost"
```

## Shorter way to get values

**Remark**: Using the short variant can result in unwanted behaviuor when jumping between different ini files using the shorten syntax for all. It is just bash :-)

If you read multiple values from the same section, you can use set file and maybe section too.

`ini.set "<inifile>"`

Get a value from ini file using ini.value with 2 parameters:

* section
* key

OR

`ini.set "<inifile>" <section>` to shorten the access with the key only.

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
general
database
...
```

### Get a section

`ini.section "<inifile>" <section>`

returns the subset from inifile with the given section name. All comments of it are removed.

```txt
key1 = "value 1"
key2 = "value 2"
...
```

### Get variable names of a section

`ini.keys "<inifile>" <section>`

returns the variable names of a section in alphabetic order

```txt
key1
key2
...
```

### Dump

With `ini.dump "<inifile>"` you get a colored output of the ini file and its parsed sections, keys and values.

Use this function if you don't get an expected value.

### Validate

There is an option to validate the syntax of your ini file with a given validation configuration.

`ini.validate "<inifile>" "<validate.ini>" [<flag>]`

The `<flag>` is optional. By default it is `0` and shows error information only on STDOUT. Set it to `1` to see more output about the validation process.

See next chapter for more details for the validation syntax.