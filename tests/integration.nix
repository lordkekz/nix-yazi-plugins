{
  pkgs,
  testYazi,
}:
let
  runYazi = pkgs.writeShellScript "run-yazi-plugin-e2e" ''
    exec ${pkgs.lib.getExe testYazi} --cwd-file "$YAZI_TEST_CWD_FILE" "$YAZI_TEST_START_DIR"
  '';
in
pkgs.runCommand "yazi-plugins-e2e"
  {
    nativeBuildInputs = [
      pkgs.coreutils
      pkgs.tmux
    ];
  }
  ''
    set -euo pipefail

    work="$TMPDIR/yazi-plugins-e2e"
    socket="$work/tmux.sock"
    bypass_stage="$work/bypass-stage"
    smart_enter_stage="$work/smart-enter-stage"
    mkdir -p "$work/home" "$work/config" "$work/data" "$work/cache"
    mkdir -p "$bypass_stage/only/child" "$smart_enter_stage/one-level"
    : > "$bypass_stage/only/child/sentinel"
    : > "$smart_enter_stage/one-level/sentinel"

    export HOME="$work/home"
    export XDG_CONFIG_HOME="$work/config"
    export XDG_DATA_HOME="$work/data"
    export XDG_CACHE_HOME="$work/cache"
    export TERM=xterm-256color
    export YAZI_TEST_CWD_FILE="$work/cwd"
    unset TMUX DISPLAY WAYLAND_DISPLAY DBUS_SESSION_BUS_ADDRESS XAUTHORITY

    cleanup() {
      tmux -S "$socket" -f /dev/null kill-server 2>/dev/null || true
    }
    trap cleanup EXIT

    run_case() {
      local session="$1"
      local start_dir="$2"
      local key="$3"
      local expected="$4"

      export YAZI_TEST_START_DIR="$start_dir"
      rm -f "$YAZI_TEST_CWD_FILE"

      # Always address this private server socket. Never use tmux's default socket.
      tmux -S "$socket" -f /dev/null new-session \
        -d -s "$session" -x 100 -y 30 -c "$start_dir" "exec ${runYazi}"

      ready=0
      for _ in $(seq 1 100); do
        if ! tmux -S "$socket" -f /dev/null has-session -t "$session" 2>/dev/null; then
          break
        fi
        command="$(tmux -S "$socket" -f /dev/null display-message -p -t "$session" '#{pane_current_command}' 2>/dev/null || true)"
        if [ "$command" = yazi ]; then
          ready=1
          break
        fi
        sleep 0.1
      done
      if [ "$ready" -ne 1 ]; then
        tmux -S "$socket" -f /dev/null capture-pane -p -t "$session" >&2 || true
        exit 1
      fi

      sleep 0.5
      tmux -S "$socket" -f /dev/null send-keys -t "$session" "$key"
      sleep 0.5
      tmux -S "$socket" -f /dev/null send-keys -t "$session" q

      for _ in $(seq 1 100); do
        [ -s "$YAZI_TEST_CWD_FILE" ] && break
        sleep 0.1
      done
      if [ ! -s "$YAZI_TEST_CWD_FILE" ]; then
        tmux -S "$socket" -f /dev/null capture-pane -p -t "$session" >&2 || true
        exit 1
      fi

      actual="$(cat "$YAZI_TEST_CWD_FILE")"
      if [ "$actual" != "$expected" ]; then
        echo "$session ended in '$actual'; expected '$expected'" >&2
        tmux -S "$socket" -f /dev/null capture-pane -p -t "$session" >&2 || true
        exit 1
      fi
      tmux -S "$socket" -f /dev/null kill-session -t "$session"
    }

    run_case bypass "$bypass_stage" F8 "$bypass_stage/only/child"
    run_case smart-enter "$smart_enter_stage" F9 "$smart_enter_stage/one-level"

    mkdir -p "$out"
    printf '%s\n' 'bypass and smart-enter navigated to their expected directories' > "$out/result"
  ''
