#!/bin/bash
source ./.auto-start.sh
source ./.pancho-sourcelist.sh
source ./.kernelup.sh
source ./.custom-list.sh
source ./.pendrive-img.sh
source ./.grafico.sh
echo "
# ================================================
# Gestion de Red y Sistema
# Derechos de creación: Francisco Figueroa
# Fecha: $(date '+%Y-%m-%d')
# ================================================
"

echo "Loading..."
sleep 3
clear
# Funcin para mostrar el men principal
menu_principal() {
clear
echo "
# ================================================
# Gestion de Red y Sistema
# Derechos de creacion: Francisco Figueroa
# Fecha: $(date '+%Y-%m-%d')
# ================================================
"
    echo "=== Gestión de Red y Sistema ==="
    echo "1. Configuración de red"
    echo "2. Gestión del sistema"
    echo "3. Gestión de usuarios"
    echo "4. Gestión de dispositivos USB"
    echo "5. Herramientas adicionales"
    echo "6. Actualizar Kernel"
    echo "7. Salir"
    echo ""
    read -p "Seleccione una opcin [1-7]: " opcion_principal

    case $opcion_principal in
        1) submenu_red ;;
        2) submenu_sistema ;;
        3) submenu_usuarios ;;
        4) submenu_usb ;;
        5) submenu_herramientas ;;
        6) menu_kernel ;;
        7) echo "Saliendo..."; exit 0 ;;
        *) echo "Opcin no valida."; sleep 2; menu_principal ;;
    esac
}

# Submenú: Configuración de red
submenu_red() {
    clear
    echo "=== Configuracion de Red ==="
    echo "1. Ver conexiones disponibles"
    echo "2. Conectar a una red Wi-Fi"
    echo "3. Configurar IP fija"
    echo "4. Configurar IP dinámica"
    echo "5. Reiniciar NetworkManager"
    echo "6. Listar IPs de los dispositivos"
    echo "7. Eliminar una conexión"
    echo "8. Instalar driver Tp-Link"
    echo "9. Volver al menu principal"
    echo ""
    read -p "Seleccione una opcion [1-8]: " opcion_red

    case $opcion_red in
        1) nmcli connection show ;;
        2)
            echo "Escaneando redes Wi-Fi..."
            nmcli device wifi list
            read -p "Ingrese el nombre de la red Wi-Fi (SSID): " ssid
            read -p "Ingrese el password de la red (o presione Enter si no tiene): " password
            if [ -z "$password" ]; then
                sudo nmcli device wifi connect "$ssid"
            else
                sudo nmcli device wifi connect "$ssid" password "$password"
            fi
            sudo nmcli connection modify "$ssid" connection.autoconnect yes
            ;;
        3)
            nmcli connection show
	    read -p "Ingrese el nombre de la conexion a configurar : " conexion
            read -p "Ingrese la IP fija (ej: 192.168.1.100/24): " ip
            read -p "Ingrese la puerta de enlace (gateway, ej: 192.168.1.1): " gateway
            read -p "Ingrese los servidores DNS (ej: 8.8.8.8,8.8.4.4): " dns
            sudo nmcli connection modify "$conexion" ipv4.method manual ipv4.addresses "$ip" ipv4.gateway "$gateway" ipv4.dns "$dns"
            sudo nmcli connection up "$conexion"
            ;;
        4)
            nmcli connection show
	    read -p "Ingrese el nombre de la conexion: " conexion
            sudo nmcli connection modify "$conexion" ipv4.method auto
            sudo nmcli connection up "$conexion"
            ;;
        5) sudo systemctl restart NetworkManager ;;
        6) ip addr show ;;
        7)
            nmcli connection show
            read -p "Ingrese el nombre de la conexion a eliminar: " conexion
            sudo nmcli connection delete "$conexion"
            ;;

        8)
            echo "Instalando controladores para placa Wi-Fi TP-Link..."
            echo "Detectando el modelo de la placa Wi-Fi..."
            modelo=$(lsusb | grep -i "TP-Link")
            if [ -n "$modelo" ]; then
                echo "Modelo detectado: $modelo"
                echo "Intentando instalar controladores necesarios..."
                sudo apt update
                sudo apt install -y dkms build-essential linux-headers-$(uname -r)
                echo "Clonando repositorio del controlador..."
                git clone https://github.com/aircrack-ng/rtl8812au.git
                cd rtl8812au || exit
                sudo make dkms_install
                cd ..
                echo "Controladores instalados. Reinicie la red para aplicar los cambios."
            else
                echo "No se detectó una placa TP-Link. Asegúrate de que esté conectada."
            fi
            ;;
        9) menu_principal ;;
        *) echo "Opción no válida."; sleep 2; submenu_red ;;
    esac

    echo ""
    read -p "Presione Enter para volver al sub-menu de Red..."
    submenu_red
}

# Submenú: Gestión del sistema
submenu_sistema() {
    clear
    echo "=== Gestion del Sistema ==="
    echo "1. Instalar paquetes con apt"
    echo "2. Actualizar y mejorar el sistema"
    echo "3. Limpiar el sistema"
    echo "4. Reparar librerias y dependencias"
    echo "5. Configurar inicio"  
    echo "6. Reiniciar el sistema"
    echo "7. Source List"
    echo "8. Apagar el sistema"
    echo "9. Volver al menu principal"
    echo ""
    read -p "Seleccione una opcion [1-7]: " opcion_sistema

    case $opcion_sistema in
        1)
            read -p "Ingrese el nombre del paquete a instalar: " paquete
            sudo apt update
            sudo apt install -y "$paquete"
            ;;
        2) sudo apt update && sudo apt upgrade -y ;;
        3) sudo apt autoremove -y && sudo apt clean ;;
        4) sudo apt install -f && sudo dpkg --configure -a ;;
        5) menu_autostart;;
        6) sudo reboot ;;
        7) gestionar_sources_list;;
        8) sudo shutdown now ;;
        9) menu_principal ;;
        *) echo "Opcion no valida."; sleep 2; submenu_sistema ;;
    esac

   # echo ""
   # read -p "Presione Enter para volver al sub-menu de Sistema..."
   # submenu_sistema
}




# Submenú: Gestión de usuarios
submenu_usuarios() {
    clear
    echo "=== Gestion de Usuarios ==="
    echo "1. Crear un usuario"
    echo "2. Eliminar un usuario"
    echo "3. Agregar usuario al grupo sudo"
    echo "4. Eliminar usuario del grupo sudo"
    echo "5. Cambiar contraseña de root o un usuario"
    echo "6. Volver al menú principal"
    echo ""
    read -p "Seleccione una opción [1-6]: " opcion_usuarios

    case $opcion_usuarios in
        1)
            read -p "Ingrese el nombre del usuario a crear: " usuario
            sudo adduser "$usuario"
            ;;
        2)
            read -p "Ingrese el nombre del usuario a eliminar: " usuario
            sudo deluser --remove-home "$usuario"
            ;;
        3)
            read -p "Ingrese el nombre del usuario a agregar al grupo sudo: " usuario
            sudo usermod -aG sudo "$usuario"
            ;;
        4)
            read -p "Ingrese el nombre del usuario a eliminar del grupo sudo: " usuario
            sudo deluser "$usuario" sudo
            ;;
        5)
            read -p "Ingrese el usuario (o presione Enter para cambiar contraseña de root): " usuario
            if [ -z "$usuario" ]; then
                sudo passwd
            else
                sudo passwd "$usuario"
            fi
            ;;
        6) menu_principal ;;
        *) echo "Opción no válida."; sleep 2; submenu_usuarios ;;
    esac

    echo ""
    read -p "Presione Enter para volver al submenú de Usuarios..."
    submenu_usuarios
}

# Submenú: Gestión de dispositivos USB
submenu_usb() {
    clear
    echo "=== Gestión de Dispositivos USB ==="
    echo "1. Listar dispositivos USB"
    echo "2. Montar un USB"
    echo "3. Desmontar un USB"
    echo "4. Volver al menú principal"
    echo ""
    read -p "Seleccione una opción [1-4]: " opcion_usb

    case $opcion_usb in
        1) lsusb ;;
        2)
            read -p "Ingrese el nombre del dispositivo USB (ej: /dev/sdb1): " usb
            read -p "Ingrese el punto de montaje (ej: /mnt/usb): " punto
            sudo mkdir -p "$punto"
            sudo mount "$usb" "$punto"
            ;;
        3)
            read -p "Ingrese el punto de montaje a desmontar (ej: /mnt/usb): " punto
            sudo umount "$punto"
            ;;
        4) menu_principal ;;
        *) echo "Opción no válida."; sleep 2; submenu_usb ;;
    esac

    echo ""
    read -p "Presione Enter para volver al submenú de USB..."
    submenu_usb
}

# Submenú: Herramientas adicionales
submenu_herramientas() {
    clear
    echo "=== Herramientas Adicionales ==="
    echo "1. Hacer ping a Google para probar conexión"
    echo "2. Instalar librerías Qt necesarias"
    echo "3. Agregar una ruta al PATH"
    echo "4. Custom List Node, Brave, Chrome, Docker, Visual"
    echo "5. Hacer PenDrive instalacion"
    echo "6  Utilidades Graficas"
    echo "7. Volver al menú principal"
    echo ""
    read -p "Seleccione una opción [1-6]: " opcion_herramientas

    case $opcion_herramientas in
        1) ping -c 4 google.com ;;
        2)
            sudo apt update
            sudo apt install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools
            ;;

	    3)
	    read -p "Ingrese la ruta que desea agregar al PATH: " ruta
            if [[ ":$PATH:" != *":$ruta:"* ]]; then
                echo "export PATH=\$PATH:$ruta" >> ~/.bashrc
                echo "La ruta $ruta ha sido agregada al PATH."
                echo "Reiniciando shell para aplicar cambios..."
                exec bash  # Reinicia el shell actual para aplicar el nuevo PATH
            else
                echo "La ruta ya está en el PATH."
            fi
            ;;
        4) menu_custom_list;;
        5) menu_pendrive_img;;
        6) menu_grafico;;
        7) menu_principal ;;
        *) echo "Opción no válida."; sleep 2; submenu_herramientas ;;
    esac

    echo ""
    read -p "Presione Enter para volver al submenú de Herramientas..."
    submenu_herramientas
}

# Iniciar el menú principal
menu_principal
