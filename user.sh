#!/bin/bash

# Función para obtener el nombre de la página web sin el dominio
get_page_name() {
    local url="$1"
    local page_name=$(echo "$url" | awk -F[/:] '{print $4}')
    echo "$page_name"
}

# Función para comprobar si el username está disponible en la URL proporcionada
check_username_availability() {
    local url="$1"
    local username="$2"

    # Realizar la solicitud HTTP GET
    local response_code=$(curl -s -o /dev/null -w "%{http_code}" "${url}${username}/")

    # Obtener el nombre de la página web
    local page_name=$(get_page_name "$url")

    # Verificar el código de respuesta
    if [ "$response_code" == "200" ]; then
        echo "¬ ${page_name}, OCUPADO"
    elif [ "$response_code" == "301" ] || [ "$response_code" == "302" ]; then
        echo "¬ ${page_name}, LIBRE"
    elif [ "$response_code" == "404" ]; then
        echo "¬ ${page_name}, LIBRE"
    else
        echo "¬ ${page_name}, No se pudo determinar '${username}'. Código de respuesta: ${response_code}"
    fi
}

# Solicitar al usuario el username a verificar
read -p "Introduce el username que deseas verificar: " username

# Lista de URLs para verificar la disponibilidad del username
urls=("https://www.instagram.com/${username}/" "https://www.tiktok.com/@${username}/" "https://www.chess.com/member/${username}" "https://github.com/${username}/" "https://www.twitch.tv/${username}/" "https://twitter.com/${username}/" "https://soundcloud.com/${username}/" "https://www.youtube.com/@${username}/" "https://pastebin.com/u/${username}/" "https://lichess.org/@/${username}/" "https://www.nodo313.net/miembros/${username}/" "https://replit.com/@${username}")

# Iterar sobre cada URL y comprobar la disponibilidad del username
for url in "${urls[@]}"; do
    check_username_availability "$url" "$username"
done
