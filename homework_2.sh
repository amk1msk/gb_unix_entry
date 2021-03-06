#1
ls /etc
ls /proc
ls /home
cat /etc/adduser.conf
cat /etc/bash.bashrc

#2
cat /etc/adduser.conf > ~/1
cat /etc/bash.bashrc > ~/2
cat ~/1 ~/2 > ~/3
less ~/3
mv ~/3 ~/4

#3
touch 5
touch 6
mkdir 7
mv 5 7
rm -r *

#4
ls -lA ~/ | awk '{print$9}' | grep "^\." | wc -l

#5
cat /etc/* 2> ~/stderr_etc
less stderr_etc | grep denied | wc -l

#6
gedit
ps aux | grep gedit
kill -15 28016
Terminated

gedit
ps aux | grep gedit
kill -9 28091
Killed

kill -1 28140
Hangup

#7
lsof -u user | grep "/dev" | less

#8
mkdir -p 20{15..20}/{01..12}

#9
cd ~/
touch ~/20{15..20}{01..12}{01..30}{01..03}.txt
for i in *.txt; do echo $i > $i; done
for i in {2015..2020}; do for j in {01..12}; do mv ~/$i$j*.txt ~/$i/$j; done; done

#10
ls -lA ~/ | cut -b 1-10 | grep -v total | sort -u | wc -l
