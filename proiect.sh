#!/bin/bash

# Funcția DFS pentru parcurgere
dfs() {
    local dir="$1"

    #  Suprascrie fișierul doar la primul apel
    if [ "$first_run" -eq 1 ]; then
        echo "Analizăm directorul: $dir" > output_directoare.txt
        first_run=0
    else
        echo "Analizăm directorul: $dir" >> output_directoare.txt
    fi

    # Parcurgem toate elementele din director
    for item in "$dir"/*; do
        # Verificăm dacă item-ul este un link simbolic
        if [ -L "$item" ]; then 
            if [ ! -e "$item" ]; then
                echo "Broken symlink găsit: $item"
                ((broken_link_count++)) # Contorizăm link-urile broken
            elif [ $follow_symlinks -eq 1 ];then
                # Obținem calea reală către directorul sau fișierul la care duce linkul simbolic
                local target
                target=$(readlink -f "$item")
                if [ -d "$target" ]; then
                dfs "$target" # Continuăm recursiv dacă target-ul este director
                fi
            fi
        elif [ -d "$item" ]; then
            dfs "$item" # Apelăm recursiv pentru subdirectoare
        fi
    done
}

# Verificăm dacă s-a dat un argument 
if [ "$#" -lt 1 ]; then
    echo "Eroare: Nu ai furnizat niciun argument"
    echo "Utilizare corecta: $0 [--follow-symlinks] <director>"
    exit 1
fi

# Inițializare variabile globale
follow_symlinks=0    # Flag pentru urmărirea linkurilor simbolice
start_dir=""         # Directorul de start
broken_link_count=0  # Contor pentru linkuri "broken"
first_run=1          # Indicator pentru prima rulare a DFS

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

# Apelăm funcția DFS pe directorul de start
dfs "$start_dir"

# Afișăm numărul de linkuri simbolice "broken" găsite
echo "Număr total de linkuri simbolice broken găsite: $broken_link_count"

# Menționăm dacă a avut loc parcurgerea recursivă
if [ $follow_symlinks -eq 1 ]; then
    echo "S-a utilizat flag-ul --follow-symlinks pentru a analiza recursiv linkurile simbolice."
else
    echo "Nu s-a utilizat flag-ul --follow-symlinks. Linkurile simbolice nu au fost analizate recursiv."
fi

# Finalizare
echo "Verificare completă!"
