#!/bin/bash

# Check if we are over SSH and not already inside a TMUX session
if [[ -z "$TMUX" && -n "$SSH_TTY" ]]; then

    # Get the list of sessions
    sessions=$(tmux ls 2>/dev/null)

    # --- DISPLAY MENU ---
    if [[ -n "$sessions" ]]; then
        echo "=========================================="
        echo "       ACTIVE TMUX SESSIONS"
        echo "=========================================="
        echo "$sessions"
        echo "=========================================="
        echo " Options:"
        echo "  - Type the ID or NAME to attach."
        echo "  - Type 'n' to create a NEW session (auto-numbered)."
        echo "  - Type 'n [name]' to create a NEW named session."
        echo "  - Press ENTER (or wait 10s) to skip TMUX."
        echo "=========================================="
    else
        echo "=========================================="
        echo "      NO ACTIVE TMUX SESSIONS"
        echo "=========================================="
        echo " Options:"
        echo "  - Type 'n' to create a NEW session (auto-numbered)."
        echo "  - Type 'n [name]' to create a NEW named session."
        echo "  - Press ENTER (or wait 10s) to skip TMUX."
        echo "=========================================="
    fi

    # --- READ INPUT ---
    read -t 10 -p ">> Your choice: " choice

    # --- LOGIC ---
    
    # 1. Empty (Enter or Timeout)
    if [[ -z "$choice" ]]; then
        echo -e "\nTimeout or Enter: Continuing without tmux..."

    # 2. Exact 'n' -> Create new auto-numbered session
    elif [[ "$choice" == "n" ]]; then
        exec tmux new-session

    # 3. Starts with 'n ' (n + space + name) -> Create new named session
    elif [[ "$choice" =~ ^n\ +(.*)$ ]]; then
        # Capture name and trim whitespace
        session_name=$(echo "${BASH_REMATCH[1]}" | xargs)
        
        # VALIDATION: Forbid naming a session "n"
        if [[ "$session_name" == "n" ]]; then
            echo -e "\nERROR: You cannot name a session 'n' (reserved keyword)."
            echo "Continuing without tmux..."
        else
            exec tmux new-session -s "$session_name"
        fi

    # 4. Anything else (Assume existing session ID/Name)
    else
        # Only try to attach if sessions existed previously
        if [[ -n "$sessions" ]]; then
            if tmux has-session -t "$choice" 2>/dev/null; then
                exec tmux attach -t "$choice"
            else
                echo -e "\nSession '$choice' does not exist. Continuing without tmux..."
            fi
        else
            # If no sessions existed and input wasn't 'n...', do nothing
            echo -e "\nInvalid option. Continuing without tmux..."
        fi
    fi
fi
