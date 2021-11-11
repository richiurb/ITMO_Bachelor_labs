# 1
# Установите из сетевого репозитория пакеты, входящие в группу «Development Tools».

dnf group install "Development Tools"
    (dnf) y     # Is this ok 


# 2
# Установите из исходных кодов, приложенных к методическим указаниям пакет bastet-0.43. Для этого необходимо создать отдельный каталог 
# и скопировать в него исходные коды проекта bastet. Вы можете использовать подключение сетевого каталога в хостовой операционной системе для передачи 
# архива с исходными кодами в виртуальную машину. Далее следует распаковать архив до появления каталога с исходными файлами 
# (в каталоге должен отображаться Makefile). После этого соберите пакет bastet и запустите его, чтобы удостовериться, что он правильно собрался. 
# Затем модифицируйте Makefile, добавив в него раздел install. Обеспечьте при установке копирование исполняемого файла в /usr/bin 
# с установкой соответствующих прав доступа. Выполните установку и проверьте, что любой пользователь может запустить установленный пакет.

cp /mnt/share/bastet-0.43.tgz ~/lab4
tar -zxvf ~/lab4/bastet-0.43.tgz    # -z - распакует полученный архив с помощью команды GZIP
                                    # -x - извлечение файлов на диск из архива
                                    # -v - показывает процесс распаковки файлов при извлечении файлов

cd ~/lab4/bastet
make    # ошибка - отсутствие boost/foreach.hpp
dnf install boost
    (dnf) y     # Is this ok
make    # ошибка - отсутствие boost/array.hpp
dnf install boost-devel
    (dnf) y     # Is this ok
make    # ошибка - отсутствие curses.h
dnf install curses-devel
    (dnf) y     # Is this ok
make

echo -e "\ninstall:\n\tinstall ./bastet /usr/bin" >> Makefile
make install

ls -l /usr/bin | grep bastet    # убедились, что любой пользователь может запустить установленный пакет


# 3
# Создайте файл task3.log, в который выведите список всех установленных пакетов.

dnf list installed > ~/lab4/task3.log


# 4
# Создайте файл task4_1.log, в который выведите список всех пакетов (зависимостей), необходимых для установки и работы компилятора gcc. 
# Создайте файл task4_2.log, в который выведите список всех пакетов (зависимостей), установка которых требует установленного пакета libgcc.

dnf repoquery --requires gcc >> ~/lab4/task4_1.log
dnf repoquery --whatrequires libgcc >> ~/lab4/task4_2.log


# 5
# Создайте каталог localrepo в домашнем каталоге пользователя root и скопируйте в него пакет checkinstall-1.6.2-3.el6.1.x86_64.rpm ,
# приложенный к методическим указаниям. Создайте собственный локальный репозиторий с именем localrepo из получившегося каталога с пакетом.

mkdir ~/localrepo
cp /mnt/share/checkinstall-1.6.2-3.el6.1.x86_64.rpm ~/localrepo

dnf install createrepo
    (dnf) y     # Is this ok
createrepo ~/localrepo
echo -e "[localrepo]\nname=localrepo\nbaseurl=file:///root/localrepo/\nenabled=1\ngpgcheck=0" >> /etc/yum.repos.d/localrepo.repo


# 6
# Создайте файл task6.log, в который выведите список всех доступных репозиториев.

dnf repolist >> ~/lab4/task6.log


# 7
# Настройте систему на работу только с созданным локальным репозиторием (достаточно переименовать конфигурационные файлы других репозиториев). 
# Выведите на экран список доступных для установки пакетов и убедитесь, что доступен только один пакет, находящийся в локальном репозитории. 
# Установите этот пакет.

mkdir ~/fake_repos
./script_task7.sh

dnf repolist    # убедились, что система настроена только на localrepo
dnf repository-packages localrepo info  # получили большую порцию информации, но из нее следует, что доступен действительно только один пакет, 
                                        # который нам и нужен
dnf install checkinstall
    (dnf) y     # Is this ok


# 8
# Скопируйте в домашний каталог пакет fortunes-ru_1.52-2_all, приложенный к методическим рекомендациям, преобразуйте его в rpm пакет и установите.

./script_task7_back.sh  # проблема - команда dnf install wget не отрабатывает (а должна), решилась возвратом конфигурационных файлов 
                        # других репозиториев на их исконное место данным скриптом

dnf install wget
wget -c https://sourceforge.net/projects/alien-pkg-convert/files/release/alien_8.95.tar.xz
tar xf alien_8.95.tar.xz
dnf install perl
cd ~/lab4/alien-8.95
perl Makefile.PL
make
make install

cd ~/lab4
alien --to-rpm fortunes-ru_1.52-2_all.deb
rpm -ivh fortunes-ru-1.52-3.noarch.rpm  # file / from install of fortunes-ru-1.52-3.noarch conflicts with file from package filesystem-3.8-3.el8.x86_64
rpm -ivh --force fortunes-ru-1.52-3.noarch.rpm  # выполнить принудительно


# 9
# Скачайте из сетевого репозитория пакет nano. Пересоберите пакет таким образом, чтобы после его установки менеджером пакетов, 
# появлялась возможность запустить редактор nano из любого каталога, введя команду newnano.

wget -c https://www.nano-editor.org/dist/v5/nano-5.9.tar.xz
tar xf nano-5.9.tar.xz

cd ~/lab4/nano-5.9
./configure --program-prefix=new    # добавляем program-prefix для того чтобы задать перфикс имени программы
make
make install

cd ~/lab4
newnano test_1.txt  # убедились, что теперь запускается nano с помощью команды newnano
