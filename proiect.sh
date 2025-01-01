#!/bin/bash

# Verificam daca s-a dat un director ca argument 
if [ "$#" -lt 1 ]; then
    echo "Utilizare: $0 [--follow-symlinks] <director>"
    echo "Exemplu: $0 --follow-symlinks /etc"
    exit 1
fi
