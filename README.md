# Sistema_Gestor_de_Logs

Proyecto que contiene los scripts encargados de la instalación de los aplicativos necesarios
para el funcionamiento del Sistema Gestor de Logs.

La instalación consistirá en dos partes: la primera la instalación de ELK (Elasticsearch, Kibana
y Logstash) en Linux y la segunda la instalación de Winlogbeat en Windows. Es necesario dar permisos de ejecución a los scripts.

## Instalación de ELK en Debian Linux
- Abrir terminal linux 
- Loguearse como root
- Descargar el script de instalación: 
```ruby
cd $HOME/Downloads
wget -c https://github.com/chr1zS/Sistema_Gestor_de_Logs/blob/main/elk_install.sh
```
- Ejecutar script de instalación
```ruby
cd $HOME/Downloads
.\elk_install.sh
```

## Instalación de Winlogbeat en Windows
- Abrir PowerShell como Administrador
- Descargar el script de instalación
```ruby
Invoke-WebRequest "https://github.com/chr1zS/Sistema_Gestor_de_Logs/blob/main/winlog_install.ps1" -OutFile "$HOME\Downloads\winlog_install.ps1"
```
- Ejecutar el script de instalación
```ruby
.\winlog_install.ps1
```
