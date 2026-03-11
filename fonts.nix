{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    #fonts
    noto-fonts-cjk-sans
    source-han-sans
    source-han-serif
  ];
}
