{ config, lib, ... }:

with lib;
let
  cfg = config.homies.configs.bash;
in
{
    options.homies.configs.bash.enable = mkEnableOption "GNU Bourne-Again SHell configuration";

    config = mkIf cfg.enable {
      programs.bash = with lib; {
        enable = true;

        historyControl = [
          "erasedups"
          "ignoredups"
          "ignorespace"
        ];

        historyIgnore = [
          "ls"
          "ls *"
          "ll"
          "ll *"
          "[bf]g"
          "cd"
          "exit"
          "mkEnableOptionps"
          "jobs"
          "set -x"
          "&"
        ];

        sessionVariables = {
          # http://help.github.com/working-with-key-passphrases/
          SSH_ENV = "$HOME/.ssh/environment";
        };

        shellOptions = [
          # Append to history file rather than replacing
          "histappend"

          # check the window size after each command and, if
          # necessary, update the values of LINES and COLUMS
          "checkwinsize"

          # Extended globbing
          "extglob"
          "globstar"

          # Warn if closing shell with running jobs
          "checkjobs"

          # Autocorrect typos in path names when using `cd`
          "cdspell"

          # e.g., `**/qux` will enter `./foo/bar/baz/qux`
          "autocd"
        ];

        shellAliases = {
          ll = "ls -alFh";
          la = "ls -A";
          l = "ls -CF";

          grep = "grep --color=auto";

          rm = "rm -i";
          cp = "cp -i --backup=numbered";
          mv = "mv -i --backup=numbered";
          mkdir = "mkdir -p";
          ln = "ln -i --backup=numbered";

          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";

          # hunt the disk hog
          duck = "du -cks * | sort -rn | head -11";

          # clear out history
          hclear = "history -c; clear";

          # https://github.com/lihaoyi/Ammonite/issues/607
          amm = "amm --no-remote-logging";
        };

        initExtra = ''
          ${builtins.readFile ./bashrc}
        '';
      };
    };
}