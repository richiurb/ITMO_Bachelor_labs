#!/bin/bash

for file in /etc/yum.repos.d/*;
do
    file_cutted=$(echo "$file" | cut -d '/' -f 4)
    if [[ "$file_cutted" != "localrepo.repo" ]];
    then
        mv "$file" ~/fake_repos
    fi
done
