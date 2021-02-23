#1. Настроить сетевой фильтр, чтобы из внешней сети можно было обратиться только к сервисам http (80 и 443) и ssh. Отключить фаервол облачного провайдера.
#3. Поставить и настроить fail2ban на блокировку SSH запросов с неверным паролем/ключом. Проверить работу fail2ban

iptables -S
-P INPUT DROP
-P FORWARD DROP
-P OUTPUT ACCEPT
-N f2b-sshd
-A INPUT -p tcp -m multiport --dports 22 -j f2b-sshd
-A INPUT -p udp -m udp --dport 68 -j ACCEPT
-A INPUT -p tcp -m multiport --dports 22 -j f2b-sshd
-A INPUT -p tcp -m multiport --dports 22,80,443,8080 -j ACCEPT
-A INPUT -p tcp -j DROP
-A INPUT -i lo -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p udp -m state --state RELATED,ESTABLISHED -j ACCEPT
-A f2b-sshd -s 83.143.192.33/32 -j REJECT --reject-with icmp-port-unreachable
-A f2b-sshd -j RETURN
-A f2b-sshd -j RETURN


netfilter-persistent save

nmap unixentry.gq
PORT     STATE  SERVICE
22/tcp   open   ssh
80/tcp   open   http
443/tcp  open   https

---------------
#2. Настроить SSH аутентификацию только по ключу, отключить парольную аутентификацию, запретить логин под root

less /etc/ssh/sshd_config | grep -v "^#"

Include /etc/ssh/sshd_config.d/*.conf
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem	sftp	/usr/lib/openssh/sftp-server

---------------
#4. * Установить certbot и получить SSL сертификат для вашего домена

sudo certbot --nginx -d unixentry.gq -d www.unixentry.gq

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Congratulations! You have successfully enabled https://unixentry.gq and
https://www.unixentry.gq
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

---------------
5. * Настроить nginx на редирект запросов с 80 порта на 443 и подключить полученные SSL сертификаты

curl -i http://unixentry.gq:80/
HTTP/1.1 301 Moved Permanently
Server: nginx/1.18.0
Date: Tue, 23 Feb 2021 15:31:28 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://unixentry.gq/

echo | openssl s_client -servername unixentry.gq -connect unixentry.gq:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
depth=2 O = Digital Signature Trust Co., CN = DST Root CA X3
verify return:1
depth=1 C = US, O = Let's Encrypt, CN = R3
verify return:1
depth=0 CN = unixentry.gq
verify return:1
DONE
-----BEGIN CERTIFICATE-----
MIIFMDCCBBigAwIBAgISA2x1XngUpzxPpkHFJILhFX/MMA0GCSqGSIb3DQEBCwUA
...
5BL44kNdS0+N1OG8MUIn1sfexqbmhwPwDXP25ZSOHU8xoUle
-----END CERTIFICATE-----

