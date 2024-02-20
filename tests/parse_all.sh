#!/bin/bash

cd "$( dirname $0 )"

. ../ini.class.sh


for myinifile in *.ini
do
    ini.dump "$myinifile"
done