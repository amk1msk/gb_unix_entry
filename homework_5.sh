
#1. Произвести ручную настройку сети в Ubuntu, на каждом шаге сделать скриншоты.
#2. Переключить настройку сети на автоматическую через DHCP, проверить получение адреса.
#3. Изменить адрес DNS на 1.1.1.1 и проверить доступность интернета, например, открыв любой браузер на адрес https://geekbrains.ru.

sudo apt install ifupdown -y

auto ens33 > /etc/network/interfaces
iface ens33 inet dhcp >> /etc/network/interfaces
iface ens33 inet static >> /etc/network/interfaces
address 192.168.88.7 >> /etc/network/interfaces
gateway 192.168.88.1 >> /etc/network/interfaces
netmask 255.255.255.0 >> /etc/network/interfaces
network 192.168.88.0 >> /etc/network/interfaces
broadcast 192.168.88.255 >> /etc/network/interfaces
dns-nameservers 1.1.1.1 8.8.8.8 >> /etc/network/interfaces

sudo service networking restart

curl https://geekbrains.ru.

#4* Настроить правила iptables, чтобы из внешней сети можно было обратиться только к портам 80 и 443. Запросы на порт 8080 перенаправлять на порт 80.
#5* Дополнительно к предыдущему заданию настроить доступ по ssh только из указанной сети. Задания со звездочкой 4-5 не обязательные, кому 1-3 показалось недостаточно.

iptables -A INPUT -p tcp --match multiport --dports 80,443 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 192.168.88.0/24 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.88.7:80
iptables -A FORWARD -p tcp --dport 8080 -m state --state NEW,ESTABLISHED,RELATED

iptables -P INPUT DROP


#6* Настроить OpenVPN, связать несколько виртуальных машин с помощью OpenVPN-туннеля. 

#in development

#7* Сделать одну из настроенных в задании выше машин шлюзом доступа в интернет. Настроить NAT.

#in development

