#!/bin/bash
menu_grafico(){
clear
echo "
 =========================================================
 Script para instalar y configurar modo gráfico en Debian
 Derechos de creación: Francisco Figueroa
 Este script permite instalar entornos de escritorio,
 gestores de ventanas, herramientas gráficas y utilidades.
 =========================================================
"

# Script para instalar herramientas gráficas y gestionar el modo gráfico en Debian
# Incluye una opción específica para configurar entorno gráfico en la BeagleBone Black

function actualizar_repositorios {
    echo "Actualizando repositorios..."
    sudo apt update && sudo apt upgrade -y
    echo "Repositorios actualizados."
}

function instalar_entorno_grafico {
    echo "Instalando entornos gráficos..."
    echo "1. LXDE (Ligero)"
    echo "2. XFCE (Ligero y completo)"
    echo "3. Openbox (Ultraligero)"
    echo "4. GNOME (Completo)"
    echo "5. KDE Plasma (Completo y pesado)"
    echo "6. Cancelar"
    read -p "Seleccione un entorno para instalar [1-6]: " opcion

    case $opcion in
        1)
            sudo apt install -y lxde xserver-xorg lightdm
            echo "Entorno LXDE instalado."
            ;;
        2)
            sudo apt install -y xfce4 xserver-xorg lightdm
            echo "Entorno XFCE instalado."
            ;;
        3)
            sudo apt install -y openbox xserver-xorg
            echo "Entorno Openbox instalado."
            ;;
        4)
            sudo apt install -y gnome xserver-xorg gdm3
            echo "Entorno GNOME instalado."
            ;;
        5)
            sudo apt install -y kde-plasma-desktop xserver-xorg sddm
            echo "Entorno KDE Plasma instalado."
            ;;
        6)
            echo "Cancelando instalación de entorno gráfico."
            ;;
        *)
            echo "Opción no válida."
            ;;
    esac
}

function configurar_entorno_grafico_bbb {
    echo "Configurando entorno gráfico para BeagleBone Black (BBB)..."
    
    # Paso 1: Actualización del sistema
    echo "1. Actualizando el sistema..."
    sudo apt update && sudo apt upgrade -y
    
    # Paso 2: Instalación del entorno gráfico
    echo "2. Instalando entornos gráficos recomendados..."
    echo "Selecciona un entorno gráfico para la BBB:"
    echo "1. LXDE (Ligero)"
    echo "2. XFCE (Ligero y funcional)"
    echo "3. Openbox (Ultraligero)"
    read -p "Elige una opción [1-3]: " opcion_bbb

    case $opcion_bbb in
        1)
            sudo apt install -y lxde xserver-xorg lightdm
            echo "LXDE instalado para la BBB."
            ;;
        2)
            sudo apt install -y xfce4 xserver-xorg lightdm
            echo "XFCE instalado para la BBB."
            ;;
        3)
            sudo apt install -y openbox xserver-xorg
            echo "Openbox instalado para la BBB."
            ;;
        *)
            echo "Opción no válida. Instalación cancelada."
            return
            ;;
    esac

    # Paso 3: Configurar inicio automático del entorno gráfico
    echo "3. Configurando inicio automático del entorno gráfico..."
    sudo apt install -y lightdm
    sudo systemctl set-default graphical.target
    echo "Entorno gráfico configurado para iniciar automáticamente."
}

function instalar_utilidades {
    echo "Instalando herramientas y utilidades gráficas..."
    sudo apt install -y gparted x11-utils xinit mesa-utils
    echo "Utilidades gráficas instaladas."
}

function instalar_gestores_de_ventana {
    echo "Instalando gestores de ventanas..."
    echo "1. i3"
    echo "2. Fluxbox"
    echo "3. IceWM"
    echo "4. Cancelar"
    read -p "Seleccione un gestor para instalar [1-4]: " opcion

    case $opcion in
        1)
            sudo apt install -y i3
            echo "Gestor de ventanas i3 instalado."
            ;;
        2)
            sudo apt install -y fluxbox
            echo "Gestor de ventanas Fluxbox instalado."
            ;;
        3)
            sudo apt install -y icewm
            echo "Gestor de ventanas IceWM instalado."
            ;;
        4)
            echo "Cancelando instalación de gestor de ventanas."
            ;;
        *)
            echo "Opción no válida."
            ;;
    esac
}

function menu_principal_grafico {
    while true; do
        echo "  ====== Menú Principal ==="
        echo "1. Actualizar repositorios y sistema"
        echo "2. Instalar entorno gráfico"
        echo "3. Configurar entorno gráfico para BeagleBone Black (BBB)"
        echo "4. Instalar herramientas y utilidades gráficas"
        echo "5. Instalar gestores de ventanas"
        echo "6. Menu Principal"
        read -p "Seleccione una opción [1-6]: " opcion

        case $opcion in
            1) actualizar_repositorios ;;
            2) instalar_entorno_grafico ;;
            3) configurar_entorno_grafico_bbb ;;
            4) instalar_utilidades ;;
            5) instalar_gestores_de_ventana ;;
            6) echo "Regresar ..."; menu_principal ;;
            *) echo "Opción no válida." ;;
        esac
    done
}

# Ejecutar el menú principal
menu_principal_grafico
}