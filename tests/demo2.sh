#!/bin/bash

cd "$( dirname $0 )"

. ../ini.class.sh


inifile=demo2.ini

echo "========== $inifile"
# cat "$inifile"
echo
echo "----- sections:"
ini.sections "$inifile"
echo
echo "----- section: section-01"
ini.section "$inifile" "section-01"
echo
echo "----- keys in section: section-01"
ini.keys    "$inifile" "section-01"
echo

ini.set "$inifile" "section-01" 
echo "----- value: var1 = [$( ini.value "var1" )]"
echo "----- value: var2 = [$( ini.value "var2" )]"
echo "----- value: var3 = [$( ini.value "var3" )]"
