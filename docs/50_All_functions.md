## ini.class.sh

List of all functions in alphabetic order

### ini.dump()

```txt
Dump the ini file for visuall check of the parsing functions
🟩 param  string  filename
```

[line: 168](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L168)

### ini.help()

```txt
Show help
```

[line: 201](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L201)

### ini.keys()

```txt
Get all keys inside a section

🌐 global  string  $INI_FILE     filename of the ini file
🌐 global  string  $INI_SECTION  section of the ini file

🟩 param   string  name of the ini file
🟩 param   string  name of the section in ini file
```

[line: 120](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L120)

### ini.section()

```txt
Get all content inside a section

🌐 global  string  $INI_FILE     filename of the ini file
🌐 global  string  $INI_SECTION  section of the ini file

🟩 param   string  name of the ini file
🟩 param   string  name of the section in ini file
```

[line: 101](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L101)

### ini.sections()

```txt
Get all sections

🌐 global  string  $INI_FILE     filename of the ini file

🟩 param   string  name of the ini file
```

[line: 89](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L89)

### ini.set()

```txt
Set the INI file - and optional section - for short calls.
🟩 param   string  filename
🔹 param   string  optional: section
```

[line: 46](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L46)

### ini.setsection()

```txt
Set the INI section for short calls.

🌐 global  string  $INI_FILE     filename of the ini file
🌐 global  string  $INI_SECTION  section of the ini file

🟩 param   string  section
```

[line: 65](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L65)

### ini.validate()

```txt
Validate the ini file
🟩 param   string  path of ini file to validate
🟩 param   string  path of ini file with validation rules
🔹 param   bool    optional: show more output; default: 0
```

[line: 313](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L313)

### ini.value()

```txt
Get a value of a variable in a given section

🌐 global  string  $INI_FILE     filename of the ini file
🌐 global  string  $INI_SECTION  section of the ini file

🟩 param   string  name of the ini file
🟩 param   string  name of the section in ini file
🟩 param   string  name of the variable to read
```

[line: 138](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L138)

### ini.varexport()

```txt
Create bash code to export all variables as hash.
Example:
  eval "$( ini.varexport "cfg_" "$inifile" )"

🟩 param   string  prefix for the variables
🟩 param   string  ini file to read
```

[line: 291](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L291)

- - -
Generated with [Bashdoc](https://github.com/axelhahn/bashdoc) v0.7
