#!/bin/bash

cd "$( dirname $0 )"

. ../ini.class.sh


inifile=demo1.ini

echo "========== $inifile"
cat "$inifile"
echo
echo "----- sections:"
ini.sections "$inifile"
echo
echo "----- section: database"
ini.section "$inifile" "database"
echo
echo "----- keys in section: database"
ini.keys    "$inifile" "database"
echo
echo "----- value: database -> server = [$( ini.value "$inifile" "database" "server" )]"
echo "----- value: database -> file   = [$( ini.value "$inifile" "database" "file" )]"
echo


echo "TEST for short calls ... setter for file and section"
echo ">" ini.set "$inifile" "database" 
ini.set "$inifile" "database" 
echo
echo "----- value: server        = [$( ini.value "server" )]"
echo "----- value: file          = [$( ini.value "file" )]"
echo "----- value: owner -> name = [$( ini.value "owner" "name" )]"
