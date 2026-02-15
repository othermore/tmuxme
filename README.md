# tmuxme.sh

**tmuxme** is a lightweight Bash script designed to manage TMUX sessions automatically upon SSH login. It provides a clean, interactive menu to list existing sessions, create new ones (named or auto-numbered), or skip TMUX entirely with a built-in timeout.

## Features

- **Auto-Detection:** Only runs if connected via SSH and not already inside a TMUX session.
- **Session Listing:** Displays all active sessions and indicates if clients are already attached.
- **Quick Actions:**
  - **Connect:** Type the ID or Name of an existing session to attach.
  - **New (Auto):** Type `n` to create a standard numbered session.
  - **New (Named):** Type `n my_session` to create a named session.
- **Timeout:** Automatically skips TMUX if no input is received within 10 seconds (useful for scripts or non-interactive logins).
- **Safety:** Prevents creating sessions named "n" to avoid command conflicts.

## Installation

1. **Download the script**
   Save the script to your home directory (or anywhere you prefer). Choose the English (`tmuxme_en.sh`) or Spanish (`tmuxme_es.sh`) version and rename it to `tmuxme.sh`.

   ```bash
   # Example: Download and rename
   curl -o ~/.tmuxme.sh [https://raw.githubusercontent.com/yourusername/tmuxme/main/tmuxme_en.sh](https://raw.githubusercontent.com/yourusername/tmuxme/main/tmuxme_en.sh)
   
   # Make it executable
   chmod +x ~/.tmuxme.sh
   ```

2. **Add it to your shell configuration**
   Open your `.bashrc` (or `.zshrc`):

   ```bash
   nano ~/.bashrc
   ```

   Add the following line at the very end of the file:

   ```bash
   # Run tmuxme on SSH login
   [[ -f ~/.tmuxme.sh ]] && . ~/.tmuxme.sh
   ```

3. **Apply changes**
   Reload your shell configuration:

   ```bash
   source ~/.bashrc
   ```

## Usage

Next time you SSH into your server, you will see a menu like this:

```text
==========================================
       ACTIVE TMUX SESSIONS
==========================================
0: 1 windows (created Sun Oct 22 10:00:00 2023)
backend: 2 windows (created Sun Oct 22 11:30:00 2023) (attached)
==========================================
 Options:
  - Type the ID or NAME to attach.
  - Type 'n' to create a NEW session (auto-numbered).
  - Type 'n [name]' to create a NEW named session.
  - Press ENTER (or wait 10s) to skip TMUX.
==========================================
>> Your choice: 
```

### Commands

| Input | Action |
| :--- | :--- |
| `0` | Connects to session ID `0`. |
| `backend` | Connects to session named `backend`. |
| `n` | Creates a new auto-numbered session (e.g., `1`). |
| `n dev` | Creates a new session named `dev`. |
| `[Enter]` | Skips TMUX and enters standard shell. |
| *(Nothing)* | Skips TMUX automatically after 10 seconds. |

## Notes

- **Naming Conflict:** The script reserves the name `n` for the "new session" command. You cannot name a session "n".
- **SSH Only:** The script checks for `$SSH_TTY` to ensure it only runs when you connect remotely, not when you open a terminal locally.

## Credits
Made by [antonio.mg](https://antonio.mg) with the help of Gemini
