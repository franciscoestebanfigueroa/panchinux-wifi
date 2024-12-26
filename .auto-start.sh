#!/bin/bash


# Variables
AUTOSTART_DIR="$HOME/.config/autostart"

# Crear la carpeta de autostart si no existe
setup_autostart_dir() {
  clear
  if [ ! -d "$AUTOSTART_DIR" ]; then
    mkdir -p "$AUTOSTART_DIR"
  fi
}

# Función para listar las aplicaciones de inicio automático
listar_autostart() {
  clear
  echo "=== Aplicaciones configuradas para inicio automático ==="
  if ls "$AUTOSTART_DIR"/*.desktop &>/dev/null; then
    ls "$AUTOSTART_DIR"/*.desktop | sed 's|.*/||' | sed 's|\.desktop||'
  else
    echo "No hay aplicaciones configuradas para el inicio automático."
    sleep 3
  fi
}

# Función para crear una nueva entrada de inicio automático
crear_autostart() {
  clear
  read -p "Ingresa el nombre de la aplicación: " app_name
  read -p "Ingresa la ruta completa del programa: " app_path

  if [ ! -f "$app_path" ]; then
    echo "Error: El programa no existe en la ruta proporcionada ($app_path)."
    sleep 3 
   return 1
  fi

  autostart_file="$AUTOSTART_DIR/$app_name.desktop"

  cat > "$autostart_file" <<EOL
[Desktop Entry]
Type=Application
Exec=$app_path
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=$app_name
Comment=Inicia $app_name al cargar el escritorio
EOL

  echo "El archivo de inicio automático se creó correctamente: $autostart_file"
}

# Función para eliminar una entrada existente
eliminar_autostart() {
  clear
  read -p "Ingresa el nombre de la aplicación a eliminar: " app_name
  autostart_file="$AUTOSTART_DIR/$app_name.desktop"

  if [ -f "$autostart_file" ]; then
    rm "$autostart_file"
    echo "Se eliminó la aplicación '$app_name' del inicio automático."
  else
    echo "Error: No se encontró la aplicación '$app_name' en $AUTOSTART_DIR."
  sleep 3
  fi
}

# Función principal para manejar el menú
menu_autostart() {
  clear
  setup_autostart_dir

  while true; do
    echo ""
    echo "=== Configuración de inicio automático ==="
    echo "1) Listar aplicaciones configuradas"
    echo "2) Crear una nueva aplicación de inicio automático"
    echo "3) Eliminar una aplicación de inicio automático"
    echo "4) Regresal al menu Principal"
    read -p "Selecciona una opción: " opcion

    case $opcion in
      1)

        listar_autostart
        ;;
      2)
        crear_autostart
        ;;
      3)
        eliminar_autostart
        ;;
      4)
        echo "Saliendo del menú..."
        clear
	menu_principal
	break
        ;;
      *)
        echo "Opción no válida, por favor intenta de nuevo."
        ;;
    esac
  done
}
