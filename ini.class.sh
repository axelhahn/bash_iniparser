#!/bin/bash
# ======================================================================
#
# READ INI FILE with Bash
# https://axel-hahn.de/blog/2018/06/08/bash-ini-dateien-parsen-lesen/
#
#  Author:  Axel hahn
#  License: GNU GPL 3.0
#  Source:  https://github.com/axelhahn/bash_iniparser
#  Docs:    https://www.axel-hahn.de/docs/bash_iniparser/
#
# ----------------------------------------------------------------------
# 2024-02-04  v0.1  Initial version
# 2024-02-08  v0.2  add ini.varexport; improve replacements of quotes
# 2024-02-10  v0.3  handle spaces and tabs around vars and values
# 2024-02-12  v0.4  rename local varables
# 2024-02-20  v0.5  handle special chars in keys; add ini.dump + ini.help
# 2024-02-21  v0.6  harden ini.value for keys with special chars; fix fetching last value
# ======================================================================

INI_FILE=
INI_SECTION=

# ----------------------------------------------------------------------
# SETTER
# ----------------------------------------------------------------------

# Set the INI file - and optional section - for short calls.
# param  string  filename
# param  string  optional: section
function ini.set(){
    INI_FILE=
    INI_SECTION=
    if [ ! -f "$1" ]; then
        echo "ERROR: file does not exist: $1"
        exit 1
    fi
    INI_FILE="$1"

    test -n "$2" && ini.setsection "$2"
    
}

# Set the INI section for short calls.
# param  string  section
function ini.setsection(){
    if [ -z "$INI_FILE" ]; then
        echo "ERROR: ini file needs to be set first. Use ini.set <FILE> [<SECTION>]."
        exit 1
    fi
    if [ -n "$1" ]; then
        if ini.sections "$INI_FILE" | grep "^${1}$" >/dev/null; then
            INI_SECTION=$1
        else
            echo "ERROR: Section [$1] does not exist in [$INI_FILE]."
            exit 1
        fi
    fi
}

# ----------------------------------------------------------------------
# GETTER
# ----------------------------------------------------------------------

# Get all sections
# param1 - name of the ini file
function ini.sections(){
        local myinifile=${1:-$INI_FILE}
        grep "^\[" "$myinifile" | sed 's,^\[,,' | sed 's,\].*,,'
}

# Get all content inside a section
# param1 - name of the ini file
# param2 - name of the section in ini file
function ini.section(){
        local myinifile=${1:-$INI_FILE}
        local myinisection=${2:-$INI_SECTION}
        sed -e "0,/^\[${myinisection}\]/ d" -e '/^\[/,$ d' $myinifile \
            | grep -v "^[#;]" \
            | sed -e "s/^[ \t]*//g" -e "s/[ \t]*=[ \t]*/=/g"
}

# Get all keys inside a section
# param1 - name of the ini file
# param2 - name of the section in ini file
function ini.keys(){
        local myinifile=${1:-$INI_FILE}
        local myinisection=${2:-$INI_SECTION}
        ini.section "${myinifile}" "${myinisection}" \
            | grep "^[\ \t]*[^=]" \
            | cut -f 1 -d "=" \
            | sort -u
}


# Get a value of a variable in a given section
# param1 - name of the ini file
# param2 - name of the section in ini file
# param3 - name of the variable to read
function ini.value(){

        if [ -n "$2" ] && [ -z "$3" ]; then
            ini.value "$INI_FILE" "$1" "$2"
        elif [ -z "$2" ]; then
            ini.value "$INI_FILE" "$INI_SECTION" "$1"
        else
            local myinifile=$1
            local myinisection=$2
            local myvarname=$3
            local out
            regex="${myvarname//[^a-zA-Z0-9:()]/.}"
            out=$(ini.section "${myinifile}" "${myinisection}" \
                | sed "s,^[\ \t]*,,g" \
                | sed "s,[\ \t]*=,=,g"  \
                | grep -F "${myvarname}=" \
                | grep "^${regex}=" \
                | cut -f 2- -d "=" \
                | sed -e 's,^\ *,,' -e 's, *$,,' 
                )
            grep "\[\]$" <<< "$myvarname" >/dev/null || out="$( echo "$out" | tail -1 )"

            # delete quote chars on start and end
            grep '^".*"$' <<< "$out" >/dev/null && out=$(echo "$out" | sed -e's,^"\(.*\)"$,\1,g')
            grep "^'.*'$" <<< "$out" >/dev/null && out=$(echo "$out" | sed -e"s,^'\(.*\)'$,\1,g")
            echo "$out"
        fi
}

# dump the ini file for visuall check of the parsing functions
# param  string  filename
ini.dump() {
    local myinifile=${1:-$INI_FILE}
    echo -en "\e[1;33m"
    echo "+----------------------------------------"
    echo "|"
    echo "| $myinifile"
    echo "|"
    echo -e "+----------------------------------------\e[0m"
    echo -e "\e[34m"
    cat "$myinifile" | sed "s,^,    ,g"
    echo -e "\e[0m"

    echo "    Parsed data:"
    echo
    ini.sections "$myinifile" | while read -r myinisection; do
        echo -e "    --+-- section \e[35m[$myinisection]\e[0m"
        echo "      |"
        ini.keys "$myinifile" "$myinisection" | while read -r mykey; do
            value="$(ini.value "$myinifile" "$myinisection" "$mykey")"
            # printf "        %-15s => %s\n" "$mykey" "$value"
            printf "      \`---- %-20s => " "$mykey"
            echo -e "\e[1;36m$value\e[0m"
        done
        echo
    done
    echo
}

function ini.help(){
    cat <<EOH

    INI.CLASS.SH

    A bash implementation to read ini files.

    Author:  Axel hahn
    License: GNU GPL 3.0
    Source:  https://github.com/axelhahn/bash_iniparser
    Docs:    https://www.axel-hahn.de/docs/bash_iniparser/

    Usage:

    (1)
    source the file ini.class.sh

    (2)
    ini.help
    to show this help with all available functions.


    BASIC ACCESS:

    ini.value <FILE> <SECTION> <KEY>
        Get a avlue of a variable in a given section.

        Tho shorten ini.value with 3 parameters:

        ini.set <FILE> [<SECTION>]

        or

        ini.set <FILE>
        ini.setsection <SECTION>

        This sets the ini file and/ or section as default.
        Afterwards you can use:

        ini.value <KEY>
        and
        ini.value <SECTION> <KEY>

    OTHER GETTERS:

    ini.sections <FILE>
        Get all sections in the ini file.
        The <FILE> is not needed if ini.set <FILE> was used before.

    ini.keys <FILE> <SECTION>
        Get all keys in the given section.
        The <FILE> is not needed if ini.set <FILE> was used before.
        The <SECTION> is not needed if ini.setsection <SECTION> was used 
        before.

    ini.dump <FILE>
        Get a nice overview of the ini file.
        You get a colored view of the content and a parsed view of the
        sections and keys + values.

EOH
}

# Create bash code to export all variables as hash.
# Example: eval "$( ini.varexport "cfg_" "$inifile" )"
#
# param  string  prefix for the variables
# param  string  ini file to read
function ini.varexport(){
    local myprefix="$1"
    local myinifile="$2"
    local var=

    for myinisection in $(ini.sections "$myinifile"); do
        var="${myprefix}${myinisection}"
        echo "declare -A ${var}; "
        echo "export ${var}; "
        
        for mykey in $(ini.keys "$myinifile" "$myinisection"); do
            value="$(ini.value "$myinifile" "$myinisection" "$mykey")"
            echo ${var}[$mykey]="\"$value\""
        done
    done
    
}
# ----------------------------------------------------------------------
