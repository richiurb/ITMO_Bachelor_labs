#!/bin/bash

# Скрипт находится в каталоге /home

val1=$(diff $1 $2)
if [[ -e $2 ]]
then
    if [[ -z $val1 ]]
    then
        echo "YES"
    else
        echo "NO"
    fi
else
    echo "NO"
fi
