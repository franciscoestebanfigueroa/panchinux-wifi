#!/bin/bash

# ==============================================
# Script para Actualizar el Kernel en Debian
# Derechos de creación: Francisco Figueroa
# Fecha: $(date '+%Y-%m-%d')
# ==============================================
menu_kernel(){

clear
echo "============================================="
echo "   Actualización del Kernel en Debian"
echo "============================================="
echo ""
echo "¡Advertencia! Asegúrate de saber lo que haces."
echo "Este proceso descargará e instalará un kernel más reciente."
echo ""

read -p "¿Deseas continuar? (s/n): " continuar

if [[ "$continuar" != "s" && "$continuar" != "S" ]]; then
    echo "Operación cancelada."
    menu_principal
    exit 0
fi

# Paso 1: Actualizar repositorios
echo "Actualizando los repositorios..."
sudo apt update

# Paso 2: Instalar herramientas necesarias
echo "Instalando herramientas necesarias..."
sudo apt install -y linux-headers-$(uname -r) linux-image-amd64 firmware-linux

# Paso 3: Buscar la última versión del kernel disponible
echo "Buscando la última versión del kernel disponible..."
sudo apt-cache search linux-image | grep "linux-image-[0-9]"

read -p "Ingresa la versión del kernel que deseas instalar (ejemplo: linux-image-6.1.0-0): " kernel_version

# Paso 4: Instalar el kernel seleccionado
echo "Instalando el kernel $kernel_version..."
sudo apt install -y $kernel_version

# Paso 5: Actualizar GRUB
echo "Actualizando GRUB..."
sudo update-grub

# Paso 6: Confirmación y reinicio
echo "El kernel ha sido actualizado correctamente."
echo "Es necesario reiniciar el sistema para aplicar los cambios."

read -p "¿Deseas reiniciar ahora? (s/n): " reiniciar
if [[ "$reiniciar" == "s" || "$reiniciar" == "S" ]]; then
    sudo reboot
else
    echo "Recuerda reiniciar el sistema más tarde para aplicar los cambios."
    exit 0
fi


}