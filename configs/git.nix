{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.homies.configs.git;

  gitalias = pkgs.fetchFromGitHub {
    owner = "GitAlias";
    repo = "gitalias";
    rev = "fb19fde1e4ec901ae7e54ef5b1c40d55cab7e86f";
    sha256 = "0axf8s6j1dg2jp637p4zs98h3a5wma5swqfld9igmyqpghpsgx5q";
  };
in
{
  options.homies.configs.git = {
    enable = mkEnableOption "git configuration";

    email = mkOption {
      type = types.str;
      default = config.homies.configs.mail.email;
      description = "Email used in authoring Git commits.";
    };

    name = mkOption {
      type = types.str;
      default = config.homies.configs.mail.name;
      description = "Name used in authoring Git commits.";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      aliases = {
        # Debug a command or alias - preceed it with `debug`
        debug = "!set -x; GIT_TRACE=2 GIT_CURL_VERBOSE=2 GIT_TRACE_PERFORMANCE=2 GIT_TRACE_PACK_ACCESS=2 GIT_TRACE_PACKET=2 GIT_TRACE_PACKFILE=2 GIT_TRACE_SETUP=2 GIT_TRACE_SHALLOW=2 git";
        # Quote / unquote a sh command, converting it to / from a git alias string
        quote-string = "!read -r l; printf \\\"!; printf %s \"$l\" | sed 's/\\([\\\"]\\)/\\\\\\1/g'; printf \" #\\\"\\n\" #";
        quote-string-undo = "!read -r l; printf %s \"$l\" | sed 's/\\\\\\([\\\"]\\)/\\1/g'; printf \"\\n\" #";
        # Push commits upstream.
        ps = "push";
        # Overrides gitalias.txt `save` to include untracked files.
        save = "stash save --include-untracked";
      };
      extraConfig = {
        color.ui = "auto";
        commit = {
          verbose = true;
          # template = "${config.xdg.dataHome}/git/template";
        };
        #core = {
        #  editor = config.home.sessionVariables."EDITOR";
        #};
        diff = {
          compactionHeuristic = true;
          indentHeuristic = true;
        };
        pull.rebase = true;
        push = {
          default = "simple";
          followTags = true;
        };
        status.showStash = true;
        stash.showPatch = true;
        submodule.fetchJobs = 4;
        rebase.autosquash = true;
        user.useConfigOnly = true;
      };
      ignores = [];
      includes = [{ path = "${gitalias}/gitalias.txt"; }];
      package = pkgs.gitAndTools.gitFull;
      userEmail = "jopecko@users.noreply.github.com"; # cfg.email
      userName = "Joe O'Pecko"; # cfg.name
    };
  };
}
