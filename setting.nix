{ self, ... }:
{
  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  # system defaults and preferences
  system = {
    primaryUser = "user";
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;

    defaults = {
      dock = {
        autohide = true;
        largesize = 110;
        tilesize = 45;
        magnification = true;
      };
    };
  };
}
