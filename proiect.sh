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
broken_link_count=0


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


# Functia DFS pentru parcurgere
DFS(){
    local dir="$1"
    echo "Analizam directorul: $dir"

    # Parcurgem toate elem din director
    for item in "$dir"/*; do
        
        # Verif daca item ul este link simbolic
        if [ -L "$item" ]; then
            if [ ! -e "$item" ]; then
                echo "Broken symlink gasit: $item"
                ((broken_link_count++)) #Contorizam link-urile broken
            elif [ $follow_symlinks -eq 1 ]; then
                # Obținem calea reală către directorul sau fișierul la care duce linkul simbolic
                local target
                target=$(readlink -f "$item")

                if [ -d "$target" ]; then
                   dfs "$target" #Continuam recursiv daca target-ul este director
                fi
            fi
        
        elif [ -d "$item" ]; then
            dfs "$item" # Apelam recursiv pentru subdirectoare
        fi

    done
}        

# Apelăm funcția DFS pe directorul de start
dfs "$start_dir"

# Afișăm numărul de linkuri simbolice broken găsite
echo "Număr total de linkuri simbolice broken găsite: $broken_link_count"
echo "Verificare completă!"