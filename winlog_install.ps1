###########################################
# Programa: winlog_install.ps1            #
# Objetivo: Instalación de Winlogbeat     #
# Autor: Christian Suárez                 #
# Fecha: 29/05/2023                       #
###########################################

# Se debe ejecutar el script como Administrador
# Dar los permisos deejecución al script

# Variable que indicará el path donde se descargará
# el fichero .zip que contendrá el ejecutable
$DOWNLOAD_FILE = "$HOME\Downloads\winlogbeat.zip"
# Variable donde se descomprimirá el fichero descargado
$DESTINATION = "C:\Program Files\"
# URL de descarga
$URL_WINLOGBEAT = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.8.0-windows-x86_64.zip"

# Descarga del fichero .zip que contendr el agente Winlogbeat
Invoke-WebRequest $URL_WINLOGBEAT -OutFile $DOWNLOAD_FILE

# Extraemos el archivo en la ruta Arhivos de Programa
Expand-Archive -LiteralPath $DOWNLOAD_FILE -DestinationPath $DESTINATION

# Variable que contrandrá el nombre de la carpeta extraida
$OLD_NAME = Get-ChildItem -Path "C:\Program Files\winlogbeat*"
# Variable que contendrá el nuevo nombre de la carpeta que contiene el ejecutable
$NEW_NAME = "C:\Program Files\winlogbeat"

# Renombramos la carpeta extraída
Rename-Item $OLD_NAME -NewName $NEW_NAME

# Accedemos a la carpeta y ejecutamos el script d einstalación
cd $NEW_NAME
.\install-service-winlogbeat.ps1

# Arrancamos el servicio y comprobamos su estado
Start-Service winlogbeat
Get-Service winlogbeat
