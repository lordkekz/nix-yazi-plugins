{
  pkgs,
  testYazis,
}:
let
  lib = pkgs.lib;
  runYazi = pkgs.writeShellScript "run-yazi-plugin-e2e" ''
    exec "$YAZI_TEST_BINARY" --cwd-file "$YAZI_TEST_CWD_FILE" \
      --chooser-file "$YAZI_TEST_CHOOSER_FILE" "$YAZI_TEST_START_DIR"
  '';

  testCases = {
    bypass = {
      yazi = testYazis.bypass;
      setup = ''
        mkdir -p "$stage/only/child"
        : > "$stage/only/child/sentinel"
      '';
      keys = [ "F8" ];
      expectedCwd = "/only/child";
    };
    smart-enter = {
      yazi = testYazis.smart-enter;
      setup = ''
        mkdir -p "$stage/one-level"
        : > "$stage/one-level/sentinel"
      '';
      keys = [ "F9" ];
      expectedCwd = "/one-level";
    };
    full-border = {
      yazi = testYazis.full-border;
      setup = "";
      keys = [ "NONE" ];
      expectedCwd = "/";
      afterMarker = "╭";
      afterMarkerState = "present";
    };
    glow = {
      yazi = testYazis.glow;
      setup = ''
        printf '%s\n' 'GLOW_PREVIEW_SENTINEL' > "$stage/preview.md"
      '';
      keys = [ "NONE" ];
      expectedCwd = "/";
      afterMarker = "GLOW_PREVIEW_SENTINEL";
      afterMarkerState = "present";
    };
    ouch = {
      yazi = testYazis.ouch;
      setup = ''
        mkdir -p "$work/archive-payload"
        printf '%s\n' 'OUCH_ARCHIVE_MEMBER' > "$work/archive-payload/OUCH_ARCHIVE_MEMBER"
        tar -cf "$stage/test.tar" -C "$work/archive-payload" .
      '';
      keys = [ "NONE" ];
      expectedCwd = "/";
      afterMarker = "OUCH_ARCHIVE_MEMBER";
      afterMarkerState = "present";
    };
    torrent-preview = {
      yazi = testYazis.torrent-preview;
      setup = ''
        ${lib.getExe pkgs.python3} - "$stage/test.torrent" <<'PY'
        def bencode(value):
            if isinstance(value, int):
                return b"i" + str(value).encode() + b"e"
            if isinstance(value, bytes):
                return str(len(value)).encode() + b":" + value
            if isinstance(value, list):
                return b"l" + b"".join(bencode(item) for item in value) + b"e"
            if isinstance(value, dict):
                return b"d" + b"".join(
                    bencode(key) + bencode(value[key]) for key in sorted(value)
                ) + b"e"
            raise TypeError(value)

        info = {
            b"length": 0,
            b"name": b"TORRENT_PREVIEW_SENTINEL",
            b"piece length": 16384,
            b"pieces": b"",
        }
        torrent = {
            b"announce": b"https://tracker.invalid/announce",
            b"info": info,
        }
        with open(__import__("sys").argv[1], "wb") as output:
            output.write(bencode(torrent))
        PY
      '';
      keys = [ "NONE" ];
      expectedCwd = "/";
      afterMarker = "TORRENT_PREVIEW_SENTINEL";
      afterMarkerState = "present";
    };
    exifaudio = {
      yazi = testYazis.exifaudio;
      setup = ''
        ${lib.getExe pkgs.python3} - "$stage/test.wav" <<'PY'
        import wave

        with wave.open(__import__("sys").argv[1], "wb") as output:
            output.setnchannels(1)
            output.setsampwidth(2)
            output.setframerate(8000)
            output.writeframes(b"\0\0" * 8000)
        PY
      '';
      keys = [ "NONE" ];
      expectedCwd = "/";
      afterMarker = "8000";
      afterMarkerState = "present";
    };
    chmod = {
      yazi = testYazis.chmod;
      setup = ''
        printf '%s\n' 'CHMOD_SENTINEL' > "$stage/mode.txt"
        chmod 644 "$stage/mode.txt"
      '';
      keys = [
        "F11"
        "TEXT:600"
        "Enter"
      ];
      expectedCwd = "/";
      verify = ''
        [ "$(stat -c '%a' "$stage/mode.txt")" = 600 ]
      '';
    };
    copy-file-contents = {
      yazi = testYazis.copy-file-contents;
      setup = ''
        printf '%s\n' 'COPY_CONTENTS_SENTINEL' > "$stage/content.txt"
      '';
      keys = [ "F12" ];
      expectedCwd = "/";
      afterMarker = "Copied 1 file(s) contents to clipboard";
      afterMarkerState = "present";
    };
    open-with-cmd = {
      yazi = testYazis.open-with-cmd;
      setup = ''
        : > "$stage/input.txt"
      '';
      keys = [
        "F12"
        "WAIT:Open with (block):"
        "C-c"
      ];
      expectedCwd = "/";
    };
    smart-filter = {
      yazi = testYazis.smart-filter;
      setup = ''
        mkdir -p "$stage/target-dir"
        : > "$stage/target-dir/sentinel"
      '';
      keys = [
        "F12"
        "TEXT:target-dir"
        "C-c"
      ];
      expectedCwd = "/target-dir";
    };
    jump-to-char = {
      yazi = testYazis.jump-to-char;
      setup = ''
        : > "$stage/alpha.txt"
        : > "$stage/zulu.txt"
      '';
      keys = [
        "F12"
        "z"
        "o"
      ];
      expectedCwd = "/";
      verify = ''
        [ "$(cat "$YAZI_TEST_CHOOSER_FILE")" = "$stage/zulu.txt" ]
      '';
    };
    relative-motions = {
      yazi = testYazis.relative-motions;
      setup = ''
        for number in 01 02 03 04 05; do
          : > "$stage/$number.txt"
        done
      '';
      keys = [
        "2"
        "j"
      ];
      expectedCwd = "/";
      afterMarker = "2j";
      afterMarkerState = "present";
    };
    bookmarks = {
      yazi = testYazis.bookmarks;
      setup = ''
        mkdir -p "$stage/target"
        : > "$stage/target/sentinel"
      '';
      keys = [
        "F8"
        "x"
        "l"
        "F9"
        "x"
      ];
      expectedCwd = "/";
    };
  };

  checks = lib.mapAttrs (
    name: test:
    pkgs.runCommand "yazi-plugin-${name}-e2e"
      {
        nativeBuildInputs = [
          pkgs.coreutils
          pkgs.gnutar
          pkgs.python3
          pkgs.tmux
        ];
      }
      ''
        set -euo pipefail

        work="$TMPDIR/yazi-plugin-${name}-e2e"
        stage="$work/stage"
        socket="$work/tmux.sock"
        session="yazi-plugin-${name}"
        mkdir -p "$work/home" "$work/config" "$work/data" "$work/cache" "$stage"
        ${test.setup}

        export HOME="$work/home"
        export XDG_CONFIG_HOME="$work/config"
        export XDG_DATA_HOME="$work/data"
        export XDG_CACHE_HOME="$work/cache"
        export TERM=xterm-256color
        export YAZI_TEST_BINARY=${lib.escapeShellArg (lib.getExe test.yazi)}
        export YAZI_TEST_START_DIR="$stage${test.startDir or "/"}"
        export YAZI_TEST_CWD_FILE="$work/cwd"
        export YAZI_TEST_CHOOSER_FILE="$work/chooser"
        unset TMUX DISPLAY WAYLAND_DISPLAY DBUS_SESSION_BUS_ADDRESS XAUTHORITY

        cleanup() {
          tmux -S "$socket" -f /dev/null kill-server 2>/dev/null || true
        }
        trap cleanup EXIT

        wait_for_marker() {
          local marker="$1"
          local state="$2"
          local screen=""
          local matched=0

          for _ in $(seq 1 100); do
            screen="$(tmux -S "$socket" -f /dev/null capture-pane -p -t "$session")"
            if [ "$state" = present ] && [[ "$screen" == *"$marker"* ]]; then
              matched=1
              break
            elif [ "$state" = absent ] && [[ "$screen" != *"$marker"* ]]; then
              matched=1
              break
            fi
            sleep 0.1
          done

          if [ "$matched" -ne 1 ]; then
            echo "$session did not reach screen marker state '$state' for '$marker'" >&2
            printf '%s\n' "$screen" >&2
            exit 1
          fi
        }

        tmux -S "$socket" -f /dev/null new-session \
          -d -s "$session" -x 100 -y 30 -c "$YAZI_TEST_START_DIR" "exec ${runYazi}"

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

        ${lib.optionalString (test.beforeMarker or null != null) ''
          wait_for_marker ${lib.escapeShellArg (test.beforeMarker or "")} present
        ''}

        sleep 0.5
        ${lib.concatMapStringsSep "\n" (
          key:
          if key == "NONE" then
            ""
          else if lib.hasPrefix "WAIT:" key then
            ''
              wait_for_marker ${
                lib.escapeShellArg (builtins.substring 5 (builtins.stringLength key - 5) key)
              } present
            ''
          else if lib.hasPrefix "TEXT:" key then
            ''
              tmux -S "$socket" -f /dev/null send-keys -t "$session" -l ${
                lib.escapeShellArg (builtins.substring 5 (builtins.stringLength key - 5) key)
              }
              sleep 0.2
            ''
          else
            ''
              tmux -S "$socket" -f /dev/null send-keys -t "$session" ${lib.escapeShellArg key}
              sleep 0.2
            ''
        ) test.keys}
        sleep 0.5

        ${lib.optionalString (test.afterMarker or null != null) ''
          wait_for_marker ${lib.escapeShellArg (test.afterMarker or "")} ${
            lib.escapeShellArg (test.afterMarkerState or "present")
          }
        ''}

        ${lib.concatMapStringsSep "\n" (key: ''
          tmux -S "$socket" -f /dev/null send-keys -t "$session" ${lib.escapeShellArg key}
        '') (test.cleanupKeys or [ ])}

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
        expected="$stage${if test.expectedCwd == "/" then "" else test.expectedCwd}"
        if [ "$actual" != "$expected" ]; then
          echo "$session ended in '$actual'; expected '$expected'" >&2
          tmux -S "$socket" -f /dev/null capture-pane -p -t "$session" >&2 || true
          exit 1
        fi
        ${test.verify or ""}
        mkdir -p "$out"
        printf '%s\n' '${name} integration passed' > "$out/result"
      ''
  ) testCases;
in
{
  inherit checks;
  aggregate =
    pkgs.runCommand "yazi-plugins-e2e"
      {
        buildInputs = builtins.attrValues checks;
      }
      ''
        mkdir -p "$out"
        echo "all plugin integration checks passed" > "$out/result"
      '';
}
