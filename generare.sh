#!/bin/bash

# Verificăm dacă s-a furnizat un director valid
if [ -z "$1" ]; then
    echo "Eroare: Nu ați furnizat niciun director!"
    echo "Utilizare: $0 <director>"
    exit 1
fi

# Directorul în care se vor crea linkurile simbolice și directoarele noi
target_dir="$1"

# Verificăm dacă directorul există
if [ ! -d "$target_dir" ]; then
    echo "Eroare: Directorul $target_dir nu există!"
    exit 1
fi

echo "Crearea directoarelor și linkurilor simbolice 'broken' în $target_dir..."

# Creăm 10 de directoare noi în target_dir
for i in {1..10}; do
    new_dir="$target_dir/new_directory_$i"
    mkdir -p "$new_dir"  # Creăm directoare noi
    echo "Director creat: $new_dir"
    
    # În fiecare director nou, vom crea 10 de linkuri simbolice "broken"
    for j in {1..10}; do
        # Definim un nume de fișier inexistent
        broken_file="$new_dir/broken_file_$j"
        # Creăm un link simbolic către fișierul inexistent
        ln -s "$broken_file" "$new_dir/link_to_broken_file_$j"
        
        # Creăm și un link simbolic care duce la un director inexistent
        broken_dir="$new_dir/broken_directory_$j"
        ln -s "$broken_dir" "$new_dir/link_to_broken_directory_$j"
    done
done

# MODIFICARE: Creăm linkuri simbolice care duc la directoare valide, pentru testare
# Aceste linkuri valide vor fi urmate în scriptul principal
ln -s "$target_dir/new_directory_1" "$target_dir/valid_link_1"
echo "Link simbolic valid creat: $target_dir/valid_link_1"

# MODIFICARE: Creăm linkuri "broken" și în directorul valid pentru testare recursivă
for j in {1..5}; do
    # Creăm linkuri simbolice "broken" în directorul valid
    broken_file="$target_dir/new_directory_1/broken_file_$j"
    ln -s "$broken_file" "$target_dir/new_directory_1/link_to_broken_file_1_${j}"
    
    broken_dir="$target_dir/new_directory_1/broken_directory_$j"
    ln -s "$broken_dir" "$target_dir/new_directory_1/link_to_broken_directory_1_${j}"
done
# /MODIFICARE
