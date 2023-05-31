#!/bin/bash
#############################################################
# Programa: elk_install.sh									#
# Objetivo: Instalación de Elasticsearch, Logstash y Kibana	#
# Autor: Christian Suárez									#
# Fecha: 29/05/2023											#
#############################################################

#Recomendación: ejecutar el script como root

#PRIMERA FASE: preparación de paquetes y conexiones
#--------------------------------------------------

#Importción de clave publica PGP de elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

#Instalación de paquete transport
apt-get -y install apt-transport-https
#Se guarda el repositorio de elasticsearch
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
#Actualización de paquetes y repositorio
apt-get -y update && apt-get -y dist-upgrade



#SEGUNDA FASE: instalación de aplicativos
#----------------------------------------

#Instalación de Elasticsearch
apt-get -y install elasticsearch
#Instalación de Kibana
apt-get -y install kibana
#Instalación de Logstash
apt-get -y install logstash

#Poner los tres aplicativos como servicios
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
/bin/systemctl enable kibana.service
/bin/systemctl enable logstash.service


#TERCERA FASE: Configuración y aranque de servicios
#--------------------------------------------------

#Iniciamos Elasticsearch
systemctl start elasticsearch.service

#Paramos Kibana (en caso de encontrarse iniciado)
systemctl stop kibana.service
#Generamos el enrollment token para conectar Elasticsearch con Kibana
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana --url "http://localhost:5601" > /tmp/enrollment_token
#Iniciamos Kibana 
systemctl start kibana.service

#Iniciamos Logstash
systemctl start logstash.service

#Cambiamos password y la almacenamos en un fichero temporal
# Esta clave se necesitará para comprobaciones
/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic > /tmp/elasticpasswd
#Comprobamos elasticsearch con un curl
curl --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic:'cat /tmp/elasticpasswd' https://localhost:9200

#Finalizamos el script
exit 0












