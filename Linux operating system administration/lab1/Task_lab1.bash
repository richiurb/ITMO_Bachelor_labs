#!/bin/bash

# Скрипт находится в каталоге /home

# 1
mkdir /home/test

# 2
ls -a --file-type --group-directories-first /etc > /home/test/list

# 3
ls -d /etc/*/ | wc -l >> /home/test/list
ls -a /etc | grep "^[.][[:alpha:]]" | wc -l >> /home/test/list

# 4
mkdir /home/test/links

# 5
ln /home/test/list /home/test/links/list_hlinks

# 6
ln -s /home/test/list /home/test/links/list_slinks

# 7
stat --print="%h\n" /home/test/links/list_hlinks  # 2
stat --print="%h\n" /home/test/list  # 2
stat --print="%h\n" /home/test/links/list_slinks  # 1
sleep 5

# 8
cat /home/test/list | wc -l >> /home/test/links/list_hlinks

# 9
./diffscript.sh /home/test/links/list_hlinks /home/test/links/list_slinks  # YES
sleep 5

# 10
mv /home/test/list /home/test/list1

# 11
./diffscript.sh /home/test/links/list_hlinks /home/test/links/list_slinks  # NO
sleep 5
# нет мягкой ссылки

# 12
# ln -d ...
# нет жёсткой ссылки на каталог

# 13
find /etc/ -name "*.conf" > list_conf

# 14
find /etc/ -maxdepth 1 -type d -name "*.d" > list_d

# 15
(cat /home/list_conf; cat /home/list_d) > list_conf_d

# 16
mkdir /home/test/.sub

# 17
cp /home/list_conf_d /home/test/.sub/

# 18
cp -b /home/list_conf_d /home/test/.sub/

# 19
find /home/test
sleep 5

# 20
man man > /home/man.txt

# 21
split -b 1K man.txt

# 22
mkdir /home/test/man.dir

# 23
mv /home/x* /home/test/man.dir/

# 24
cat /home/test/man.dir/* > /home/test/man.dir/man.txt

# 25
./script.sh /home/man.txt /home/test/man.dir/man.txt  # YES
sleep 5

# 26
echo -e "My name is Rikhard.\nI am 20 years old." > temp
cat /home/man.txt >> temp
mv temp /home/man.txt
echo "It's end of file" >> /home/man.txt

# 27
diff /home/man.txt /home/test/man.dir/man.txt > /home/patchfile.patch

# 28
mv /home/patchfile.patch /home/test/man.dir/

# 29
patch /home/test/man.dir/man.txt -i /home/test/man.dir/patchfile.patch

# 30
./script.sh /home/man.txt /home/test/man.dir/man.txt
sleep 5
