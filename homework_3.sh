#!/bin/bash

: '1. Создать файл file1 и наполнить его произвольным содержимым. Скопировать его в file2. Создать символическую ссылку file3 на file1. Создать жесткую ссылку file4 на file1. Посмотреть, какие айноды у файлов. Удалить file1. Что стало с остальными созданными файлами? Попробовать вывести их на экран.'

echo "hallo" > file1
cp file1 file2
ln -s file1 file3
ln file1 file4
ls -lai
rm file1
ls -lai
cat file2 file3 file4
: 'hallo
cat: file3: No such file or directory
hallo'

: '2. Дать созданным файлам другие, произвольные имена. Создать новую символическую ссылку. Переместить ссылки в другую директорию.'

mv file2 file5
mv file4 file6
ln -s file5 file7
mkdir dir1
mv file3 file7 dir1

: '3. Создать два произвольных файла. Первому присвоить права на чтение, запись для владельца и группы, только на чтение — для всех. Второму присвоить права на чтение, запись — только для владельца. Сделать это в численном и символьном виде.'

touch file10 file11
chmod ug=rw,o=r file10
chmod 664 file10
chmod u=rw,go=- file11
chmod 660 file11

: '4. Создать пользователя, обладающего возможностью выполнять действия от имени суперпользователя.'

sudo useradd -m -G sudo -s /bin/bash suser
sudo passwd suser

: '5. * Создать группу developer и несколько пользователей, входящих в нее. Создать директорию для совместной работы. Сделать так, чтобы созданные одними пользователями файлы могли изменять другие пользователи этой группы.'

sudo groupadd developer
sudo useradd -m -G developer -s /bin/bash ivanov
sudo useradd -m -G developer -s /bin/bash petrov
sudo passwd ivanov
sudo passwd petrov

sudo /opt/developer
sudo chown :developer /opt/developer
sudo chmod g+rwxs /opt/developer

: '6. * Создать в директории для совместной работы поддиректорию для обмена файлами, но чтобы удалять файлы могли только их создатели.'

sudo mkdir /opt/developer/tmp
sudo chown :developer /opt/developer/tmp/
sudo chmod g+rwxst /opt/developer/tmp

: '7. * Создать директорию, в которой есть несколько файлов. Сделать так, чтобы открыть файлы можно было, только зная имя файла, а через ls список файлов посмотреть было нельзя.'

mkdir dir2
touch dir2/file{12..14}
chmod -rwx dir2
sudo cat dir2/file12
