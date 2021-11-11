#!/bin/bash

for file in ~/fake_repos/*;
do
    mv "$file" /etc/yum.repos.d
done
