# Crush Multi-Agent Launcher
_crush-run() {
    # 1. Try to start the watchdog.
    # Because of the singleton check above, it won't duplicate.
    ./ai-lock-watchdog.sh > /dev/null 2>&1 &

    # 2. Run Crush with whatever arguments you passed
    # Using 'command' ensures we hit the real crush CLI, not an alias
    crush "$@"
}

alias crush-run='_crush-run'