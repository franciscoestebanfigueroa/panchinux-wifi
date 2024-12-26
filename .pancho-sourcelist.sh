# Función para gestionar el sources.list en Debian
gestionar_sources_list() {
 # source .pancho.sh	 
  SOURCES_LIST="/etc/apt/sources.list"
  BACKUP_DIR="$HOME/sources_backup"
  DEBIAN_VERSION=$(lsb_release -cs) # Detecta automáticamente la versión de Debian (bullseye o bookworm)

  # Crear el directorio de backups si no existe
  mkdir -p "$BACKUP_DIR"

  while true; do
    echo ""
    echo "=== Gestión de sources.list de APT ==="
    echo "1) Listar los repositorios actuales"
    echo "2) Agregar un nuevo repositorio"
    echo "3) Hacer una copia de seguridad de sources.list"
    echo "4) Restaurar una copia de seguridad"
    echo "5) Crear un sources.list por defecto (Debian 11 o 12)"
    echo "6) Actualizar repositorios con apt update"
    echo "7) Salir"
    read -p "Selecciona una opción: " opcion

    case $opcion in
      1)  # Listar repositorios actuales
        echo "=== Contenido actual de $SOURCES_LIST ==="
        if [ -f "$SOURCES_LIST" ]; then
          cat "$SOURCES_LIST"
        else
          echo "El archivo $SOURCES_LIST no existe."
        fi
        ;;
      2)  # Agregar un nuevo repositorio
        read -p "Ingresa el repositorio que deseas agregar (línea completa): " nuevo_repo
        if [[ $nuevo_repo == http* ]]; then
          echo "$nuevo_repo" | sudo tee -a "$SOURCES_LIST"
          echo "Repositorio agregado: $nuevo_repo"
        else
          echo "Error: La línea proporcionada no parece ser un repositorio válido."
        fi
        ;;
      3)  # Hacer una copia de seguridad
        backup_file="$BACKUP_DIR/sources.list.backup.$(date +%Y%m%d%H%M%S)"
        sudo cp "$SOURCES_LIST" "$backup_file"
        echo "Se creó una copia de seguridad en: $backup_file"
        ;;
      4)  # Restaurar una copia de seguridad
        echo "=== Copias de seguridad disponibles ==="
        ls "$BACKUP_DIR" | grep sources.list.backup
        read -p "Ingresa el nombre del archivo de backup a restaurar: " backup_file_name
        if [ -f "$BACKUP_DIR/$backup_file_name" ]; then
          sudo cp "$BACKUP_DIR/$backup_file_name" "$SOURCES_LIST"
          echo "Se restauró el archivo $SOURCES_LIST desde $BACKUP_DIR/$backup_file_name"
        else
          echo "Error: No se encontró el archivo de backup especificado."
        fi
        ;;
      5)  # Crear un sources.list por defecto para Debian 11 o 12
        echo "Creando un sources.list por defecto para Debian $DEBIAN_VERSION..."
        sudo cp "$SOURCES_LIST" "$BACKUP_DIR/sources.list.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null
        if [ "$DEBIAN_VERSION" = "bullseye" ]; then
          sudo tee "$SOURCES_LIST" > /dev/null <<EOL
deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free

deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free
EOL
        elif [ "$DEBIAN_VERSION" = "bookworm" ]; then
          sudo tee "$SOURCES_LIST" > /dev/null <<EOL
deb http://deb.debian.org/debian bookworm main contrib non-free
deb-src http://deb.debian.org/debian bookworm main contrib non-free

deb http://security.debian.org/debian-security bookworm-security main contrib non-free
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free

deb http://deb.debian.org/debian bookworm-updates main contrib non-free
deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free
EOL
        else
          echo "Error: Esta función solo soporta Debian bullseye (11) y bookworm (12)."
        fi
        echo "Se configuró el sources.list por defecto para Debian $DEBIAN_VERSION."
        ;;
      6)  # Actualizar los repositorios
        echo "Actualizando la lista de paquetes..."
        sudo apt update
        ;;
      7)  # Salir
        echo "Saliendo de la gestión de sources.list..."
        break
        ;;
      *)
        echo "Opción no válida, intenta de nuevo."
        ;;
    esac
  done
}
