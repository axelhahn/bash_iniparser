## What is it?

This project is written in Bash. 

### Read data

The main features are around reading sections and values from an INI file. 

This component offers functions to get

* a list of existing sections
* a list of variables in a given section
* values of a value in a given section 

You can get values as 

* integer
* string
* arrays as multiline strings

### Verify

You have functions to control what is parsed from a given ini file:

* you can dump the ini file to see the parsed data of your file
* there is optional validation to check sections, keys in sections and their values.
