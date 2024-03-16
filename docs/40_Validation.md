## Introduction

You can check the syntax of an ini file for your script.
This is helpful if users can customize configurations and you want to ensure that your basic script gets all wanted data.

The validation feature is a helper - it does not stop the script on a found error. But it sends a non zero returncode on error to add this in your script.

```bash
if ! ini.validate "<inifile>" "<validate.ini>" [<flag>]; then
    echo "Aborting."
    exit 1
fi
# continue
echo "OK: Validation of '<inifile>' was successful"

```

## Features

* Define allowed chars for section names and keys
* Define sections that must exist or can exist
* Define which keys per section must exist or can exist
* Define kind of values per ini value

## Validation config

I wanted to abstract it nicely and put my validation rules into an ini file which is parsed by ini.class too.


### Example validation ini

To give an impression ... this is an example file... or a template to begin.
All texts inside `<`and `>` are placeholders.

```ini
# ======================================================================
#
# VALIDATION INI FOR XYZ
#
# ======================================================================

# ----------------------------------------------------------------------
# Naming conventions for section names and keys of a section
#
# SYNTAX
# One regex for sections and one for all key in all sections
# ----------------------------------------------------------------------

[style]
section  = "^[a-zA-Z0-9_]*$"
key      = "^[a-zA-Z0-9_\-]*$"

# ----------------------------------------------------------------------
# section names
#
# SYNTAX:
# comma separated list of sections
# ----------------------------------------------------------------------
[sections]
must = "<section1>[,<sectionN>]>"
can  = ""

# ----------------------------------------------------------------------
# validate keys in sections
#
# SYNTAX:
# <section>.<key> = "<VALIDATION_TYPE>[:<VALIDATION_VALUE>]"
# VALIDATION_TYPE:
# - INTEGER
# - REGEX:<REGEX_TO_VALIDATE>
# - ONEOF:<VALUE1[,<VALUE_N>]>
# ----------------------------------------------------------------------

[varsMust]
<section1>.<key1> = "REGEX:.*"
<section1>.<key2> = "INTEGER"

<section2>.<key1> = "ONEOF:<word1[,<wordN>]>"

[varsCan]
<section1>.<key3> =
<section1>.<key4> =

<section2>.<key2> =
<section2>.<key3> =
<section2>.<key4> =
<section2>.<key5> =

# ----------------------------------------------------------------------
```

### Strategies

* The simplest approach is to define a section `[style]` with 2 regex. But there the level of control is quite low.<br>OR
* A complete control you get with the definitions in `[sections]` and `[varsMust]` + `[varsCan]`. With the combination of entries that must exist and can exist all non existing sections or keys will be detected.

### Section 'style'

The section 'style' contains naming conventions for section names and keys of a section.
The is one regex for sections and one for all key in all sections.


| Key     | Description                    | Type     | Value
|---      |---                             |---       |---
| section | Regex for section names        | {string} | `"^[a-zA-Z0-9_]*$"`
| key     | Regex for keys in all sections | {string} | `"^[a-zA-Z0-9_\-]*$"`


### Section 'sections'

The secion `[sections]` contains 2 keys.

| Key     | Description                    | Type     | Value
|---      |---                             |---       |---
| must    | Section names that MUST exist  | {string} | A comma seperated list of section names
| can     | Section names that CAN exist   | {string} | A comma seperated list of section names

### Sections 'varsMust' + 'varsCan'

The logic is the same like in the sections: there are definitions for keys that MUST exist and keys that CAN exist (but can be absent).

For both section the syntax of entries is the same:

`<section>.<key> = [<validation_rule>]`

* The key of an entry is section name + dot + name of the key.
* optional: a validation rule. 
  * If it is missed then just the value must exist and there is no check for the value.
  * A validation rule is defined as `<Keyword>[:<value>]`. For all known validation rules see the table below

| Keyword         | Description                        | Type     | Value
|---              |---                                 |---       |---
| none            | Checks the existance of a key only |          |
| `INTEGER`       | The value must be an integer       |          |
| `ONEOF:<list>`  | The value must be one of the strings in a given list  | {string} | The list is a string with comma seperated values eg. `<value1>,<value2>,<valueN>`
| `REGEX:<regex>` | The value must match the given regex | {regex} | A regex like `^[a-z]*$`. You need to add starting and ending character (`^` and `$`) to verify the complete value. I use `grep -E` to check extended regex.
