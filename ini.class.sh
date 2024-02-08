#!/bin/bash
# ======================================================================
#
# READ INI FILE with Bash
# https://axel-hahn.de/blog/2018/06/08/bash-ini-dateien-parsen-lesen/
#
# ----------------------------------------------------------------------
# 2024-02-04  v0.1  Initial version
# 2024-02-08  v0.2  add ini.varexport; improve replacements of quotes
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
        local myfile=$1
        grep "^\[" "$myfile" | sed 's,^\[,,' | sed 's,\].*,,'
}

# Get all content inside a section
# param1 - name of the ini file
# param2 - name of the section in ini file
function ini.section(){
        local myfile=$1
        local mysection=$2
        sed -e "0,/^\[${mysection}\]/ d" -e '/^\[/,$ d' $myfile | grep -v "^[#;]"
}

# Get all keys inside a section
# param1 - name of the ini file
# param2 - name of the section in ini file
function ini.keys(){
        local myfile=$1
        local mysection=$2
        ini.section "${myfile}" "${mysection}" \
            | grep "^[\ \t]*[^=]" \
            | cut -f 1 -d "="
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
            local myfile=$1
            local mysection=$2
            local myvarname=$3
            local out
            out=$(ini.section "${myfile}" "${mysection}" \
                | grep "^[\ \t]*${myvarname}[\ \t]*=.*" \
                | cut -f 2 -d "=" \
                | sed -e 's,^\ *,,' -e 's, *$,,' 
                )
            grep "\[\]$" <<< "myvarname" >/dev/null && out="echo $out | tail -1"

            # delete quote chars on start and end
            grep '^".*"$' <<< "$out" >/dev/null && out=$(echo "$out" | sed -e's,^"\(.*\)"$,\1,g')
            grep "^'.*'$" <<< "$out" >/dev/null && out=$(echo "$out" | sed -e"s,^'\(.*\)'$,\1,g")
            echo "$out"
        fi
}

# Create bash code to export all variables as hash.
# Example: eval "$( ini.varexport "cfg_" "$inifile" )"
#
# param  string  prefix for the variables
# param  string  ini file to read
function ini.varexport(){
    local myprefix="$1"
    local myfile="$2"
    local var=

    for mysection in $(ini.sections "$myfile"); do
        var="${myprefix}${mysection}"
        echo "declare -A ${var}; "
        echo "export ${var}; "
        
        for mykey in $(ini.keys "$myfile" "$mysection"); do
            value="$(ini.value "$myfile" "$mysection" "$mykey")"
            echo ${var}[$mykey]="\"$value\""
        done
    done
    
}
# ----------------------------------------------------------------------
