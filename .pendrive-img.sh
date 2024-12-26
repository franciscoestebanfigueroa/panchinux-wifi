#!/bin/bash

# ================================================
# Script para crear un pendrive booteable e instalar Debian
# Derechos de creación: Francisco Figueroa
# ================================================


menu_pendrive_img(){


# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script requiere permisos de administrador."
  sudo "$0" "$@"
  exit
fi

# Funciones
function descargar_iso() {
  echo "Descargando la imagen ISO de Debian..."
  echo "Selecciona la versión de Debian que deseas descargar:"
  echo "1. Debian Stable (Bookworm)"


  read -p "Elige una opción : " opcion
  case $opcion in
    1)
      URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso" # Actualiza esta URL con la versión exacta
      ;;
    
    *)
      echo "Opción inválida. Saliendo."
      exit 1
      ;;
  esac

  read -p "Ingresa el nombre del archivo para guardar la ISO (ej: debian.iso): " iso_destino
  wget -O "$iso_destino" "$URL"

  if [ $? -ne 0 ]; then
    echo "Error al descargar la imagen ISO. Verifica tu conexión y la URL."
    exit 1
  fi

  echo "Descarga completada: $iso_destino"
}

function crear_pendrive_booteable() {
  lsblk
  read -p "Selecciona el dispositivo USB donde deseas escribir la ISO (ej: /dev/sdX): " dispositivo

  if [ ! -b "$dispositivo" ]; then
    echo "El dispositivo $dispositivo no existe."
    exit 1
  fi

  echo "ADVERTENCIA: Se borrarán todos los datos en $dispositivo."
  read -p "¿Estás seguro? Escribe 'SI' para continuar: " confirmacion

  if [ "$confirmacion" != "SI" ]; then
    echo "Operación cancelada."
    exit 1
  fi

  read -p "Ingresa la ruta de la imagen ISO (o presiona Enter para descargar una): " iso_path

  if [ -z "$iso_path" ]; then
    descargar_iso
    iso_path="$iso_destino"
  elif [ ! -f "$iso_path" ]; then
    echo "El archivo $iso_path no existe."
    exit 1
  fi

  echo "Escribiendo la ISO en el dispositivo USB..."
  dd if="$iso_path" of="$dispositivo" bs=4M status=progress conv=fdatasync

  if [ $? -ne 0 ]; then
    echo "Error al escribir la imagen en el USB."
    exit 1
  fi

  sync
  echo "La imagen ISO se ha escrito correctamente en $dispositivo."
  echo "Tu pendrive ya está listo para instalar Debian."
}

# Menú principal
echo "=== Crear Pendrive Booteable ==="
echo "1. Descargar imagen ISO de Debian y crear pendrive booteable"
echo "2. Usar una ISO local para crear pendrive booteable"
echo "3. Salir"

read -p "Selecciona una opción [1-3]: " opcion_menu
case $opcion_menu in
  1)
    descargar_iso
    crear_pendrive_booteable
    ;;
  2)
    crear_pendrive_booteable
    ;;
  3)
    echo "Saliendo..."
    exit 0
    ;;
  *)
    echo "Opción inválida."
    exit 1
    ;;
esac

}
menu_principal