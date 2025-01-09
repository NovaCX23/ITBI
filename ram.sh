#!/bin/bash

# Script pentru a crea un RAM Disk și a configura mediul pentru testare

# Setarea dimensiunii RAM Disk-ului (poți schimba această valoare după nevoie)
RAM_DISK_SIZE="64M"

# Directorul în care se va monta RAM disk-ul
MOUNT_POINT="/mnt/ramdisk"

# Verificăm dacă scriptul este rulat cu permisiuni de root (administrator)
if [ "$(id -u)" -ne 0 ]; then
    echo "Eroare: Acest script trebuie rulat cu permisiuni de root (administrator)."
    exit 1
fi

# Funcția pentru a crea și monta RAM Disk-ul
create_ramdisk() {
    echo "Creăm RAM Disk-ul de dimensiune $RAM_DISK_SIZE..."
    mkdir -p "$MOUNT_POINT"  # Creăm directorul dacă nu există deja
    mount -t tmpfs -o size=$RAM_DISK_SIZE tmpfs "$MOUNT_POINT"  # Montăm RAM disk-ul
    if [ $? -eq 0 ]; then
        echo "RAM Disk creat și montat cu succes în $MOUNT_POINT."
    else
        echo "Eroare la crearea sau montarea RAM Disk-ului!"
        exit 1
    fi
}

# Funcția pentru a copia fișiere în RAM Disk
copy_files_to_ramdisk() {
    echo "Copiem fișierele din /etc în RAM Disk..."
    cp -r /etc/* "$MOUNT_POINT/"  # Copiem fișierele din /etc 
    if [ $? -eq 0 ]; then
        echo "Fișiere copiate cu succes în RAM Disk."
    else
        echo "Eroare la copierea fișierelor."
        exit 1
    fi
}

# Funcția pentru a crea un link simbolic
create_symlink() {
    echo "Creăm un link simbolic..."
    ln -s "$MOUNT_POINT/etc" /tmp/test_symlink  # Creăm un link simbolic în /tmp
    if [ $? -eq 0 ]; then
        echo "Link simbolic creat cu succes."
    else
        echo "Eroare la crearea link-ului simbolic."
        exit 1
    fi
}

# Funcția pentru a demonta RAM Disk-ul
unmount_ramdisk() {
    echo "Demontăm RAM Disk-ul..."
    umount "$MOUNT_POINT"
    if [ $? -eq 0 ]; then
        echo "RAM Disk demontat cu succes."
    else
        echo "Eroare la demontarea RAM Disk-ului."
        exit 1
    fi
}

# Afisăm meniul și opțiunile
echo "Acest script va crea și configura un RAM Disk pentru testare."
echo "Dimensiunea RAM Disk-ului: $RAM_DISK_SIZE"
echo "Vor fi efectuate următoarele acțiuni:"
echo "1. Creare RAM Disk"
echo "2. Copiere fișiere în RAM Disk"
echo "3. Creare link simbolic"
echo "4. Demontare RAM Disk"
echo ""
read -p "Doriți să continuați? (y/n): " answer
if [[ "$answer" != "y" ]]; then
    echo "Scriptul a fost oprit de utilizator."
    exit 0
fi

# Rulează fiecare funcție pas cu pas
create_ramdisk
copy_files_to_ramdisk
create_symlink
echo "Pași finalizați! Acum poți folosi RAM Disk-ul pentru testare."

# Oferă opțiunea de a demonta RAM Disk-ul la final
read -p "Doriți să demontați RAM Disk-ul acum? (y/n): " unmount_answer
if [[ "$unmount_answer" == "y" ]]; then
    unmount_ramdisk
else
    echo "RAM Disk rămâne montat. Poți demonta manual mai târziu."
fi

echo "Script finalizat."
