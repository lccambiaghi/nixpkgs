{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = (if pkgs.stdenv.isDarwin then 14 else 12);
      strip_trailing_spaces = "smart";
      enable_audio_bell = "no";
      term = "xterm-256color";
      macos_titlebar_color = "background";
      macos_option_as_alt = "yes";
      scrollback_lines = 10000;
      shell =  "/etc/profiles/per-user/luca/bin/fish"; # TODO how to avoid hardcoding?
    };
    extraConfig = ''
      allow_hyperlinks yes
      allow_remote_control yes
      enable_audio_bell no
      tab_bar_style powerline

      enabled_layouts splits

      # open new split (window) with cmd+d retaining the cwd
      map cmd+d new_window_with_cwd
      # new split with default cwd
      map cmd+shift+d new_window
      # switch between next and previous splits
      map cmd+]        next_window
      map cmd+[        previous_window

      # jump to beginning and end of word
      map alt+left send_text all \x1b\x62
      map alt+right send_text all \x1b\x66
      # jump to beginning and end of line
      map cmd+left send_text all \x01
      map cmd+right send_text all \x05
    '';
    # font = {
    #   package = pkgs.jetbrains-mono;
    #   name = "JetBrains Mono";
    # };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
    };
  };

}
