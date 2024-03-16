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
# 2024-03-17  v0.7  add ini.validate
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
        sed -e "0,/^\[${myinisection}\]/ d" -e '/^\[/,$ d' "$myinifile" \
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

    # local _self
    # if _is_sourced; then
    #     _self="ini."
    # else
    #     _self="$( basename "$0" ) "
    # fi

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

# validate the ini file
function ini.validate(){

    function _vd(){
        test "$bShowAll" -ne "0" && echo "$*"
    }

    local myinifile="$1"
    local myvalidationfile="$2"
    local bShowAll="${3:-0}"

    local ERROR="\e[1;31mERROR\e[0m"
    local iErr; typeset -i iErr=0

    # TODO: make all used vars local

    _vd "START: Validate ini '${myinifile}'"
    _vd "       with '${myvalidationfile}'"
    if [ ! -f "${myinifile}" ]; then
        echo -e "$ERROR: Ini file in first param '${myinifile}' does not exist."
        return 1
    fi

    if [ ! -f "${myvalidationfile}" ]; then
        echo -e "$ERROR: Validation file in 2nd param '${myvalidationfile}' does not exist."
        return 1
    fi

    eval "$( ini.varexport "validate_" "$myvalidationfile" )"
    
    if [ -z "${validate_sections[*]}" ]; then
        echo -e "$ERROR: Validation file in 2nd param '${myvalidationfile}' has no section definition [sections]."
        echo "       Hint: Maybe it is no validation file (yet) or you flipped the parameters."
        return 1
    fi
    if [ -z "${validate_varsMust[*]}${validate_varsCan[*]}" ]; then
        echo -e "$ERROR: Validation file in 2nd param '${myvalidationfile}' has no key definition [varsMust] and [varsCan]."
        echo "       Hint: Maybe it is no validation file (yet) or you flipped the parameters."
        return 1
    fi


    # ----- Check if all MUST sections are present
    if [ -n "${validate_sections['must']}" ]; then
        _vd "--- Sections that MUST exist:"
        for section in $( tr "," " " <<< "${validate_sections['must']}");
        do
            if ini.sections "$myinifile" | grep -q "^$section$" ; then
                _vd "OK: Section [$section] is present."
            else
                echo -e "$ERROR: Section [$section] is not present."
                iErr+=1
            fi
        done
    fi

    # ----- Loop over sections
    _vd "--- Validate section names"
    for section in $( ini.sections "$myinifile" )
    do
        # ----- Check if our section name has the allowed syntax
        if ! grep -q "${validate_style['section']}" <<< "$section" ; then
            echo -e "$ERROR: Section [$section] violates style rule '${validate_style['section']}'"
        fi

        # ----- Check if our sections are in MUST or CAN
        if ! grep -Fq ",${section}," <<< ",${validate_sections['must']},${validate_sections['must']},"; then
            echo -e "$ERROR: Unknown section name: [$section] - ist is not listed as MUST nor CAN."
            iErr+=1
        else
            _vd "OK: section [$section] is valid"
            _vd "  Check keys of section [$section]"

            # ----- Check MUST keys in the current section
            for myKeyEntry in "${!validate_varsMust[@]}"; do
                if ! grep -q "^${section}\." <<< "${myKeyEntry}"; then
                    continue
                fi
                mustkey="$( echo "$myKeyEntry" | cut -f2 -d '.')"
                # TODO
                keyregex="$( echo "$mustkey" | sed -e's,\[,\\[,g' )"
                if ini.keys "$myinifile" "$section" | grep -q "^${keyregex}$"; then
                    _vd "  OK: [$section] -> $mustkey is a MUST"
                else
                    echo -e "  $ERROR: [$section] -> $mustkey is a MUST key but was not found im section [$section]."
                    iErr+=1
                fi

            done

            # ----- Check if our keys are MUST or CAN keys
            for mykey in $( ini.keys "$myinifile" "$section"); do

                if ! grep -q "${validate_style['key']}" <<< "$mykey" ; then
                    echo -e "$ERROR: Key [$section] -> $mykey violates style rule '${validate_style['key']}'"
                fi

                keyregex="$( echo "${mykey}" | sed -e's,\[,\\[,g' | sed -e's,\],\\],g' )"

                local mustKeys
                mustKeys="$( echo "${!validate_varsMust[@]}" | tr ' ' ',')"
                local canKeys
                canKeys="$( echo "${!validate_varsCan[@]}" | tr ' ' ',')"

                if ! grep -Fq ",${section}.$mykey," <<< ",${canKeys},${mustKeys},"; then
                    echo -e "  $ERROR: [$section] -> $mykey is invalid."
                    iErr+=1
                else

                    local valKey
                    valKey="${section}.${mykey}"
                    if [ -n "${validate_varsCan[$valKey]}" ] && [ -n "${validate_varsMust[$valKey]}" ]; then
                        echo -e "  $ERROR: '$valKey' is defined twice - in varsMust and varsCan as well. Check validation file '$myvalidationfile'."
                    fi

                    sValidate="${validate_varsCan[${section}.${mykey}]}"
                    if [ -z "$sValidate" ]; then
                        sValidate="${validate_varsMust[${section}.${mykey}]}"
                    fi
                    if [ -z "$sValidate" ]; then
                        _vd "  OK: [$section] -> $mykey exists (no check)"
                    else
                        local checkType
                        local checkValue
                        local value

                        checkType=$( cut -f 1 -d ':' <<< "$sValidate" )
                        checkValue=$( cut -f 2- -d ':' <<< "$sValidate" )
                        value="$(ini.value "$myinifile" "$section" "$mykey")"
                        local regex
                        case $checkType in
                            'INTEGER') regex="^[1-9][0-9]*$"          ;;
                            'ONEOF')   regex="^(${checkValue//,/|})$" ;;
                            'REGEX')   regex="$checkValue"            ;;
                            *)
                                echo -e "  $ERROR: ceck type '$checkType' is not supported."
                        esac
                        if [ -n "$regex" ]; then
                            if ! grep -Eq "${regex}" <<< "$value" ; then
                                echo -e "  $ERROR: [$section] -> $mykey is valid but value '$value' does NOT match '$regex'"
                            else
                                _vd "  OK: [$section] -> $mykey is valid and value matches '$regex'"
                            fi
                        fi

                    fi
                fi
            done
        fi
    done

    if [ $iErr -gt 0 ]; then
        echo "RESULT: Errors were found for $myinifile"
    else
        _vd "RESULT: OK, Ini file $myinifile looks fine."
    fi
    return $iErr

}

# ----------------------------------------------------------------------
