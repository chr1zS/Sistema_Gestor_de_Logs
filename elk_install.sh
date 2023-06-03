#!/bin/bash
#############################################################
# Programa: elk_install.sh									                #
# Objetivo: Instalación de Elasticsearch, Logstash y Kibana	#
# Autor: Christian Suárez									                  #
# Fecha: 29/05/2023											                    #
#############################################################

#Ejecutar el script como root

echo PRIMERA FASE: preparación de paquetes y conexiones
echo --------------------------------------------------

echo Importción de clave publica PGP de elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echoInstalación de paquete transport
apt-get -y install apt-transport-https
echo Se guarda el repositorio de elasticsearch
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
echo Actualización de paquetes y repositorio
apt-get -y update && apt-get -y dist-upgrade


echo SEGUNDA FASE: instalación de aplicativos
echo ----------------------------------------

echo Instalación de Elasticsearch
echo ----------------------------
apt-get -y install elasticsearch

echo Instalación de Kibana
echo ---------------------
apt-get -y install kibana

echo Instalación de Logstash
echo -----------------------
apt-get -y install logstash

echo Configuración de aplicativos como servicios
echo -------------------------------------------
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
/bin/systemctl enable kibana.service
/bin/systemctl enable logstash.service


echo TERCERA FASE: Arranque de servicios
echo echo ------------------------------

echo Iniciamos Elasticsearch
systemctl start elasticsearch.service

echo Paramos Kibana (en caso de encontrarse iniciado)
systemctl stop kibana.service

echo Generamos el enrollment token para conectar Elasticsearch con Kibana
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana --url "http://localhost:5601" > /tmp/enrollment_token
echo El enrollment token se ha guardado temrporalmente en /tmp/enrollment_token. Si se reinicia el servidor, el enrollmento token se perderá

echo Iniciamos Kibana 
systemctl start kibana.service

echo Iniciamos Logstash
systemctl start logstash.service

echo Cambiamos password y la almacenamos en un fichero temporal
# Esta clave se necesitará para comprobaciones y para acceder a Elastic
/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -s > /tmp/elasticpasswd
echo La password se ha guardado temrporalmente en /tmp/elasticpasswd. Si se reinicia el servidor, el fichero elasticpasswd se perderá

echo Comprobamos elasticsearch con un curl
PASS=$(cat /tmp/elasticpasswd)
curl --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic:$PASS https://localhost:9200

#Finalizamos el script
exit 0












