#!/bin/bash

menu_custom_list(){


# Derechos de creación: Francisco Figueroa
# Fecha: $(date '+%Y-%m-%d')

# Ruta donde se agregarán los archivos de repositorios

REPO_DIR="/etc/apt/sources.list.d"

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse como root o usando sudo."
    sudo "$0" "$@"
    exit 
fi

# Crear los archivos de repositorios con contenido
create_repo_file() {
    local filename="$1"
    local content="$2"

    echo "Creando $REPO_DIR/$filename..."
    echo -e "$content" > "$REPO_DIR/$filename"
}

# Configuraciones para cada repositorio
create_repo_file "archive_uri-https_deb_tableplus_com_debian_22-bookworm.list" \
"deb [trusted=yes] https://deb.tableplus.com/debian/22 bookworm main"

create_repo_file "nodesource.list" \
"deb https://deb.nodesource.com/node_18.x bookworm main
# deb-src https://deb.nodesource.com/node_18.x bookworm main"

create_repo_file "brave-browser-release.list" \
"deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"

create_repo_file "pgadmin4.list" \
"deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/bookworm pgadmin4 main"

create_repo_file "docker.list" \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable"

create_repo_file "vscode.list" \
"deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main"

create_repo_file "google-chrome.list" \
"deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main"

# Actualizar la lista de paquetes
echo "Actualizando la lista de paquetes..."
sudo apt update

# Confirmar que los archivos se agregaron correctamente
echo "Archivos creados en $REPO_DIR:"
ls "$REPO_DIR"

echo "Script completado."

}
menu_principal