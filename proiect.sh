#!/bin/bash

# Verificam daca s-a dat un director ca argument 
if [ "$#" -lt 1 ]; then
    echo "Utilizare: $0 [--follow-symlinks] <director>"
    echo "Exemplu: $0 --follow-symlinks /etc"
    exit 1
fi

# Initializare varibile
follow_symlinks=0
start_dir=""

# Verif primul argument 
if [ "$1" == "--follow-symlinks" ]; then
    follow_symlinks=1
    start_dir="2"         # Directorul este al doilea arg
else
    start_dir="1"         # Dir este primul arg
fi
