{
  inputs,
  inputs',
  lib,
  pkgs,
  repoRoot,
  ...
}:
{
  home-manager.sharedModules = lib.singleton (
    { config, ... }:
    let
      discordPackage = pkgs.discord.override {
        withMoonlight = true;
        inherit (inputs'.moonlight.packages) moonlight;
      };
    in
    {
      imports = [
        inputs.moonlight.homeModules.default
      ];

      home.packages = [
        discordPackage
      ];

      xdg.configFile."moonlight-mod/stable.json".source = config.lib.file.mkOutOfStoreSymlink (
        repoRoot + "/modules/programs/discord/stable.json"
      );

      xdg.dataFile."disblock-origin/theme.css".text = ''
        ${lib.readFile (pkgs.disblock-origin + /share/DisblockOrigin.theme.css)}

        :root {
          --display-badges: none;                            /* Nitro and Booster badges on user profiles */
          --display-gif-button: true;                        /* GIF button in chat bar */
          --display-sticker-button: none;                    /* Sticker button in chat bar */
          --display-emoji-button: unset;                     /* Emoji button in chat bar */
          --display-hover-reaction-emoji: unset;             /* Emoji suggestions on message hover */
          --display-app-launcher: none;                      /* App launcher right of chat bar */
          --bool-super-reaction-hide-anim: true;             /* Replace Super Reactions with a blink animation */
          --display-super-reactions: unset;                  /* Hide super reactions entirely */
          --display-profile-effects: none;                   /* Effects on profile cards */
          --display-avatar-decorations: none;                /* Decorations on top of avatars */
          --display-nameplates: none;                        /* Hide nameplates in the members list */
          --display-active-now: unset;                       /* Active Now column in friends list */
          --display-clan-tags: unset;                        /* Clan tags next to the usernames */
          --display-server-settings-boost-tab: none;         /* Server settings menu Boost tab */
          --bool-show-name-gradients: true;                  /* Gradients & glow in usernames, boosted servers only */
          --display-server-members-activity: unset;          /* Hide servers members activity list */
          --bool-show-server-banners: true;                  /* Show server banners in the channel list */
          --bool-show-profile-banner: true;                  /* Show profile banner */
          --bool-show-profile-modal-background-banner: true; /* Show profile modal background banner */
          --display-voice-status: unset;                     /* Prevent popups related to voice room status */

          --bool-settings-payment-section: true;             /* Settings menu toggle ENTIRE PAYMENT SECTION */
          --display-settings-nitro-tab: none;                /* Settings menu Nitro tab */
          --display-settings-server-boost-tab: none;         /* Settings menu Server Boost tab */
          --display-settings-subscriptions-tab: none;        /* Settings menu Subscriptions tab */
          --display-settings-gift-inventory-tab: unset;      /* Settings menu Gift Inventory tab */
          --display-nitro-features: none;                    /* Settings menu Billing tab, Super React toggle, GIF Avatar */
        }
      '';
    }
  );
}
