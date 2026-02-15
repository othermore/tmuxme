#!/bin/bash

# Comprobamos si estamos por SSH y no estamos ya dentro de una sesión tmux
if [[ -z "$TMUX" && -n "$SSH_TTY" ]]; then

    # Obtenemos el listado de sesiones
    sessions=$(tmux ls 2>/dev/null)

    # --- MOSTRAR MENÚ ---
    if [[ -n "$sessions" ]]; then
        echo "=========================================="
        echo "   SESIONES TMUX ACTIVAS"
        echo "=========================================="
        echo "$sessions"
        echo "=========================================="
        echo " Opciones:"
        echo "  - Escribe el ID o NOMBRE para conectar."
        echo "  - Escribe 'n' para crear una NUEVA (auto-numerada)."
        echo "  - Escribe 'n [nombre]' para crear una NUEVA con nombre."
        echo "  - Presiona ENTER (o espera 10s) para seguir SIN tmux."
        echo "=========================================="
    else
        echo "=========================================="
        echo "   NO HAY SESIONES ACTIVAS"
        echo "=========================================="
        echo " Opciones:"
        echo "  - Escribe 'n' para crear una NUEVA (auto-numerada)."
        echo "  - Escribe 'n [nombre]' para crear una NUEVA con nombre."
        echo "  - Presiona ENTER (o espera 10s) para seguir SIN tmux."
        echo "=========================================="
    fi

    # --- LECTURA DE ENTRADA ---
    read -t 10 -p ">> Tu elección: " choice

    # --- LÓGICA DE PROCESAMIENTO ---
    
    # 1. Si está vacío (Enter o Timeout)
    if [[ -z "$choice" ]]; then
        echo -e "\nTimeout o Enter: Continuando sin tmux..."

    # 2. Si es exactamente 'n' -> Crea nueva sin nombre (automática)
    elif [[ "$choice" == "n" ]]; then
        exec tmux new-session

    # 3. Si empieza por 'n ' (n + espacio + nombre) -> Intenta crear nueva con nombre
    elif [[ "$choice" =~ ^n\ +(.*)$ ]]; then
        # Capturamos el nombre eliminando espacios extra al inicio/final
        session_name=$(echo "${BASH_REMATCH[1]}" | xargs)
        
        # VALIDACIÓN: Prohibir llamar a la sesión "n"
        if [[ "$session_name" == "n" ]]; then
            echo -e "\nERROR: No está permitido llamar 'n' a una sesión."
            echo "Continuando sin tmux..."
        else
            exec tmux new-session -s "$session_name"
        fi

    # 4. Si escribió otra cosa (se asume que quiere conectar a una existente)
    else
        # Solo intentamos conectar si existen sesiones
        if [[ -n "$sessions" ]]; then
            if tmux has-session -t "$choice" 2>/dev/null; then
                exec tmux attach -t "$choice"
            else
                echo -e "\nLa sesión '$choice' no existe. Continuando sin tmux..."
            fi
        else
            # Si no hay sesiones y escriben algo raro, no hacemos nada
            echo -e "\nOpción no válida. Continuando sin tmux..."
        fi
    fi
fi
