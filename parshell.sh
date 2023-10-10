#!/bin/zsh

# Inicializamos las variables
ip=""
port=""
file=""
service=""
help_menu=0
endpoint=0

# Función para mostrar el menú de ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo "Script para hacer algo útil."
    echo ""
    echo "Opciones:"
    echo "  --ip       Dirección IP"
    echo "  --port     Puerto"
    echo "  --file     Nombre del archivo"
    echo "  --service  Nombre del servicio"
    echo "  -h         Muestra este menú de ayuda"
}

# Comprobar si no se han proporcionado argumentos
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

# Iteramos sobre todos los argumentos
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --ip)
        ip="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        --port)
        port="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        --file)
        file="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        --service)
        service="$2"
        shift # Pasamos al siguiente argumento
        shift # Pasamos al siguiente argumento
        ;;
        -h)
        help_menu=1
        shift # Pasamos al siguiente argumento
        ;;
        --endpoint)
        endpoint=1
        shift # Pasamos al siguiente argumento
        ;;
        *)    # Cualquier argumento no reconocido
        echo "Argumento no reconocido: $1"
        exit 1
        ;;
    esac
done

# Si se activó el menú de ayuda, lo mostramos
if [[ $help_menu -eq 1 ]]; then
    show_help
    exit 0
fi


awk_endpoint="awk 'BEGIN { ip=\"\"; port=\"\" } /Nmap scan/ { if(ip!=\"\") { print ip \":\" port; ip=\"\"; port=\"\" } ip=\$NF } /[0-9]+\\/tcp/ { port=\$1; sub(/\\/tcp/, \"\", port); print ip \":\" port } END { if(ip!=\"\") { print ip \":\" port } }' | sort -u"



# Ahora puedes usar las variables $ip, $port y $file como quieras
echo "IP: $ip"
echo "Port: $port"
echo "File: $file"
echo "Service: $service"
echo
echo

# Recuerda que solo aplica sobre los ficheros con terminación .nmap!
if [[ -z "$file" ]]; then
    # file="*"
    file=$(find \-name "*.nmap" | xargs)
fi







# Después de tu bucle while y la asignación de valores por defecto

# Asumimos que 'file' nunca estará vacío, como has indicado

if [[ -n "$ip" && -z "$port" && -z "$service" ]]; then
    echo "Buscar toda la información relativa a la IP $ip."
    echo
    # Buscar toda la información relativa a una IP
    if [[ $endpoint -eq 1 ]]; then
        eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }' | eval "$awk_endpoint"
    else
        eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }'
    fi


elif [[ -n "$ip" && -n "$port" && -z "$service" ]]; then
    echo "Buscar la información al par IP-puerto"
    echo
    eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }' | awk -v port="$port" 'BEGIN {flag=0} $1 ~ port "/tcp" {flag=1} flag && /^[0-9]+\/tcp/ && $1 !~ port "/tcp" {flag=0} flag'
    

elif [[ -z "$ip" && -n "$port" && -z "$service" ]]; then
    echo "Devolviendo toda la información relativa al puerto $port"
    echo
    if [[ $endpoint -eq 1 ]]; then
            eval "cat $file" | awk -v port="$port" 'BEGIN {flag=0; last_nmap=""} /Nmap scan/ {last_nmap=$0} $1 ~ port "/tcp" {flag=1; if (last_nmap != "") {print "\n" last_nmap; last_nmap=""}} flag && /^[0-9]+\/tcp/ && $1 !~ port "/tcp" {flag=0} flag' | eval "$awk_endpoint"
    else
        eval "cat $file" | awk -v port="$port" 'BEGIN {flag=0; last_nmap=""} /Nmap scan/ {last_nmap=$0} $1 ~ port "/tcp" {flag=1; if (last_nmap != "") {print "\n" last_nmap; last_nmap=""}} flag && /^[0-9]+\/tcp/ && $1 !~ port "/tcp" {flag=0} flag'
    fi

elif [[ -z "$ip" && -z "$port" && -n "$service" ]]; then
    echo "Buscando el servicio $service."
    echo
    # Si se activó el menú de ayuda, lo mostramos
    if [[ $endpoint -eq 1 ]]; then
        eval "cat $file" | awk -v pattern="$service" 'BEGIN {last_nmap=""; final_nmap=""} /Nmap scan/ {last_nmap=$0; final_nmap=$0} $0 ~ pattern {if (last_nmap != "") {print last_nmap; last_nmap=""} print $0} END {if (final_nmap != "") {print "\nÚltimo Nmap scan: " final_nmap}}' | eval "$awk_endpoint"
    else
        eval "cat $file" | awk -v pattern="$service" 'BEGIN {last_nmap=""; final_nmap=""} /Nmap scan/ {last_nmap=$0; final_nmap=$0} $0 ~ pattern {if (last_nmap != "") {print last_nmap; last_nmap=""} print $0} END {if (final_nmap != "") {print "\nÚltimo Nmap scan: " final_nmap}}'
    fi
    
else
    echo "Otro caso no especificado."
    # Código para manejar otros casos
fi



#cat 118.180.60.0_23.md | grep -E "Nmap scan|^80/tcp" | grep -E -B1 "80/tcp" | grep -E "Nmap scan" | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sed 's/$/:80/g'
#
#setopt null_glob
#
#port="80"
#setopt null_glob
## file="*"
#service="Microsoft IIS"

## Filtrar por puertos - Devuelveme los activos con el puerto x abierto
### en formato 10.10.10.10:80
#eval "cat $file" | grep -E "Nmap scan|^$port/tcp|^$port/udp" | grep -E -B1 "$port/" | grep -E "Nmap scan" | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sed "s/$/:$port/g"
#
### Filtrar por puerto con todos los detalles
#eval "cat $file" | awk -v port="$port" 'BEGIN {flag=0; last_nmap=""} /Nmap scan/ {last_nmap=$0} $1 ~ port "/tcp" {flag=1; if (last_nmap != "") {print last_nmap; last_nmap=""}} flag && /^[0-9]+\/tcp/ && $1 !~ port "/tcp" {flag=0} flag'
#
#
## Filtrar por IP - Muestra el contenido original relativo a una IP
#ip="118.180.61.84"
#eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }'
#
#eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }'
#
#
## Filtrar IP:Puerto
ip=
#eval "cat $file" | awk -v ip="$ip" '/^$/ { flag=0 } { if(flag) print } $0 ~ ip { print; flag=1 }' | awk -v port="$port" 'BEGIN {flag=0} $1 ~ port "/tcp" {flag=1} flag && /^[0-9]+\/tcp/ && $1 !~ port "/tcp" {flag=0} flag'
#
#
## Servicios
#eval "cat $file" | awk -v pattern="$service" 'BEGIN {last_nmap=""} /Nmap scan/ {last_nmap=$0} $0 ~ pattern {if (last_nmap != "") {print last_nmap; last_nmap=""} print $0}' | grep -P "$service"
#
#
#TODO:
#Definir distintas funciones que ejecutar según los parámetros utilizados