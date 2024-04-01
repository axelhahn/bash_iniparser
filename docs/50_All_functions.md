## ini.class.sh

List of all functions in alphabetic order

### ini.dump()

```txt
Dump the ini file for visuall check of the parsing functions
🟩 param  string  filename
```

[line: 163](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L163)

### ini.help()

```txt
Show help
```

[line: 196](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L196)

### ini.keys()

```txt
Get all keys inside a section

🌐 global  string  $INI_FILE     filename of the ini file
🌐 global  string  $INI_SECTION  section of the ini file

🟩 param   string  name of the ini file
🟩 param   string  name of the section in ini file
```

[line: 115](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L115)

### ini.section()

```txt
Get all content inside a section

🌐 global  string  $INI_FILE     filename of the ini file
🌐 global  string  $INI_SECTION  section of the ini file

🟩 param   string  name of the ini file
🟩 param   string  name of the section in ini file
```

[line: 100](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L100)

### ini.sections()

```txt
Get all sections

🌐 global  string  $INI_FILE     filename of the ini file

🟩 param   string  name of the ini file
```

[line: 88](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L88)

### ini.set()

```txt
Set the INI file - and optional section - for short calls.
🟩 param   string  filename
🔹 param   string  optional: section
```

[line: 45](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L45)

### ini.setsection()

```txt
Set the INI section for short calls.

🌐 global  string  $INI_FILE     filename of the ini file
🌐 global  string  $INI_SECTION  section of the ini file

🟩 param   string  section
```

[line: 64](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L64)

### ini.validate()

```txt
Validate the ini file
🟩 param   string  path of ini file to validate
🟩 param   string  path of ini file with validation rules
🔹 param   bool    optional: show more output; default: 0
```

[line: 308](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L308)

### ini.value()

```txt
Get a value of a variable in a given section

🌐 global  string  $INI_FILE     filename of the ini file
🌐 global  string  $INI_SECTION  section of the ini file

🟩 param   string  name of the ini file
🟩 param   string  name of the section in ini file
🟩 param   string  name of the variable to read
```

[line: 133](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L133)

### ini.varexport()

```txt
Create bash code to export all variables as hash.
Example:
eval "$( ini.varexport "cfg_" "$inifile" )"

🟩 param   string  prefix for the variables
🟩 param   string  ini file to read
```

[line: 286](https://github.com/axelhahn/bash_iniparser/blob/main/ini.class.sh#L286)

