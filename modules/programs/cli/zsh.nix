{
  lib,
  pkgs,
  ...
}:
{
  # Disable bash entirely
  programs.bash.enable = false;

  programs.zsh = {
    enable = true;
    interactiveShellInit = "fastfetch";
  };
  users.defaultUserShell = pkgs.zsh;
  home-manager.sharedModules = lib.singleton (
    { config, ... }:
    {
      programs.zsh = {
        enable = true;

        history = {
          size = 100000;
          save = 100000;
          ignoreDups = true;
          ignoreSpace = true;
          expireDuplicatesFirst = true;
          path = "${config.xdg.dataHome}/zsh/history";
        };

        initContent = ''
          # Smart edit: use $EDITOR if writable, otherwise sudoedit
          edit() {
            if [[ -z "$1" ]]; then
              echo "usage: e <file>"
              return 1
            fi
            
            if [[ -w "$1" || ! -e "$1" ]]; then
              ''${EDITOR:-nano} "$@"
            else
              sudo -e "$@"
            fi
          }
        '';

        prezto = {
          enable = true;
          caseSensitive = false;
          color = true;
          pmodules = [
            "environment"
            "terminal"
            "editor"
            "history"
            "directory"
            "spectrum"
            "utility"
            "completion"
            "history-substring-search"
            "autosuggestions"
            "syntax-highlighting"
            "git"
            "archive"
            "tmux"
            "ssh"
            "prompt"
          ];
          editor = {
            keymap = "vi";
            dotExpansion = true;
            promptContext = true;
          };
          utility.safeOps = true;
          git.submoduleIgnore = "dirty";
          prompt = {
            theme = "sorin";
            pwdLength = "short";
            showReturnVal = true;
          };
          terminal = {
            autoTitle = true;
            windowTitleFormat = "%n@%m: %s";
            tabTitleFormat = "%m: %s";
            multiplexerTitleFormat = "%s";
          };
          tmux = {
            autoStartLocal = false;
            autoStartRemote = false;
            defaultSessionName = "main";
          };
          historySubstring = {
            foundColor = "fg=cyan,bold";
            notFoundColor = "fg=red,bold";
          };
          syntaxHighlighting = {
            highlighters = [
              "main"
              "brackets"
              "pattern"
              "root"
            ];
            styles = {
              command = "fg=cyan,bold";
              builtin = "fg=cyan";
              function = "fg=blue,bold";
              alias = "fg=magenta";
              path = "fg=yellow";
              arg0 = "fg=cyan";

              single-quoted-argument = "fg=green";
              double-quoted-argument = "fg=green";
              dollar-quoted-argument = "fg=green";
              back-quoted-argument = "fg=magenta";

              single-hyphen-option = "fg=blue";
              double-hyphen-option = "fg=blue";

              unknown-token = "fg=red,bold,bg=default";
              reserved-word = "fg=yellow,bold";

              comment = "fg=243";

              globbing = "fg=magenta,bold";
              history-expansion = "fg=blue,bold";

              command-substitution-unquoted = "fg=magenta";
              command-substitution-quoted = "fg=magenta";
            };
            pattern = {
              "*rm*-rf*" = "fg=white,bold,bg=red";
              "*--force*" = "fg=yellow,bold,bg=red";
              "sudo*" = "fg=white,bold,bg=blue";
            };
          };
          completions.ignoredHosts = [
            "0.0.0.0"
            "127.0.0.1"
          ];
          ssh.identities = [
            "id_ed25519"
            "id_github"
          ];
          extraConfig = ''
            #
            # Better completion
            #
            zstyle ':completion:*' menu select
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
            zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
            zstyle ':completion:*' squeeze-slashes true 

            #
            # Navigation
            #
            setopt AUTO_CD
            setopt AUTO_PUSHD
            setopt PUSHD_IGNORE_DUPS

            #
            # fzf integration
            #
            if command -v fzf-share >/dev/null; then
              source "$(fzf-share)/key-bindings.zsh"
              source "$(fzf-share)/completion.zsh"
            fi

            #
            # zoxide
            #
            if command -v zoxide >/dev/null; then
              eval "$(zoxide init zsh)"
            fi
          '';
        };
      };
    }
  );
  nixdesk.core.storage.systemDisk.impermanence.user.dirs = [
    "@dataHome/zsh"
  ];
}
