#!/bin/bash

# Verificăm dacă sunt suficiente argumente
if [ "$#" -lt 1 ]; then
    echo "Eroare: Nu ai furnizat niciun argument"
    echo "Utilizare corecta: $0 [--follow-symlinks] <director>"
    exit 1
fi

# Initializare variabile
follow_symlinks=0
start_dir=""

# Verificăm dacă utilizatorul a folosit flag-ul --follow-symlinks
if [ "$1" == "--follow-symlinks" ]; then
    follow_symlinks=1
    start_dir="$2"  # Directorul este al doilea argument
else
    start_dir="$1"  # Directorul este primul argument
fi

# Debugging: afișăm valoarea directorului
echo "Directorul specificat: $start_dir"

# Verificăm dacă directorul a fost specificat și dacă este valid
if [ -z "$start_dir" ] || [ ! -d "$start_dir" ]; then
    echo "Eroare: Directorul specificat nu este valid!"
    echo "Utilizare: $0 [--follow-symlinks] <director>"
    exit 1
fi
