{
  home = {
    sessionVariables = {
      MANPAGER = "nvim +Man!";
      MANWIDTH = "999";
      GOPATH = "$HOME/.local/share/go";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/share/go/bin"
      "$HOME/.fnm"
      "$HOME/.local/share/neovim/bin"
      "/opt/homebrew/anaconda3/bin"
      "$HOME/.docker/bin"
    ];
  };
}
