#!/bin/sh
## SCRIPT de IPTABLES
## 
echo -n "Firewall ... Iniciando ...\n"


## FLUSH de reglas
sudo iptables --flush
sudo iptables --delete-chain
sudo iptables --zero
sudo iptables --t nat --flush

## Establecemos politica por defecto

sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -t nat -P PREROUTING ACCEPT
sudo iptables -t nat -P POSTROUTING ACCEPT

## Empezamos a filtrar
## Nota: eth0 es el interfaz conectado al router y eth1 a la LAN
# El localhost se deja (por ejemplo conexiones locales a mysql)

sudo /sbin/iptables -A INPUT -i lo -j ACCEPT

# Al firewall tenemos acceso desde la red local

sudo iptables -A INPUT -s 127.0.0.1 -i eth1 -j ACCEPT

# Ahora hacemos enmascaramiento de la red local
# y activamos el BIT DE FORWARDING (imprescindible!!!!!)

#sudo iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o eth0 -j ACCEPT

# Con esto permitimos hacer forward de paquetes en el firewall, o sea
# que otras máquinas puedan salir a traves del firewall.

#sudo echo 1 > /proc/sys/net/ipv4/ip_forward

## Y ahora cerramos los accesos indeseados del exterior:
# Nota: 0.0.0.0/0 significa: cualquier red
# Cerramos el rango de puerto bien conocido


sudo iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 1:79 	-j DROP
sudo iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 80 		-j ACCEPT
sudo iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 81:442 	-j DROP
sudo iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 443 		-j ACCEPT
sudo iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 444:1024 	-j DROP
#sudo iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 1024:65535 	-j DROP

sudo iptables -A INPUT -s 0.0.0.0/0 -p udp --dport 1:79 	-j DROP
sudo iptables -A INPUT -s 0.0.0.0/0 -p udp --dport 80 		-j ACCEPT
sudo iptables -A INPUT -s 0.0.0.0/0 -p udp --dport 81:442 	-j DROP
sudo iptables -A INPUT -s 0.0.0.0/0 -p udp --dport 443 		-j ACCEPT
sudo iptables -A INPUT -s 0.0.0.0/0 -p udp --dport 444:1024 	-j DROP
#sudo iptables -A INPUT -s 0.0.0.0/0 -p udp --dport 1024:65535 	-j DROP


echo " OK . Verifique que lo que se aplica con: iptables -L -n\n"

# Fin del script

echo -n "Firewall ... Finalizando ...\n"

echo -n "Viendo configuracion final ... \n"

sudo iptables -L -n

echo -n "Configuracion visualizada ... \n"




