{
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;
    escapeTime = 5;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
    '';
  };
}
