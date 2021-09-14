#!/bin/bash

# Скрипт находится в каталоге /home

val1=$(diff $1 $2)
if [[ -z $val1 ]]
then
echo "YES"
else
echo "NO"
fi
