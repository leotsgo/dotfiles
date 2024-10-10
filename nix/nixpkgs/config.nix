{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        ripgrep
        tmux
        neovim
        lazygit
        fzf
        eza
        bat
        jq
        yq
        zk
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}

