{...}: let
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "18px";
    font_weight = "bold";
    text_color = "#FBF1C7";
    background_0 = "#1D2021";
    background_1 = "#282828";
    border_color = "#928374";
    red = "#CC241D";
    green = "#98971A";
    yellow = "#FABD2F";
    blue = "#458588";
    magenta = "#B16286";
    cyant = "#689D6A";
    orange = "#D65D0E";
    opacity = "1";
    indicator_height = "2px";
  };
in {
  programs.waybar.style = with custom; ''
    * {
      border: none;
      border-radius: 0px;
      padding: 0;
      margin: 0;
      font-family: ${font};
      font-weight: ${font_weight};
      opacity: ${opacity};
      font-size: ${font_size};
    }

    window#waybar {
      background: #282828;
    }

    /* Multi-layered GTK3 tooltip configuration to guarantee perfect font and background visibility */
    tooltip, .tooltip, #tooltip {
      background-color: ${background_1};
      background: ${background_1};
      border: 1px solid ${border_color};
      border-radius: 4px;
    }
    tooltip label, .tooltip label, #tooltip label {
      color: ${text_color};
      font-family: ${font};
      font-size: 14px;
      padding: 4px;
    }

    #workspaces {
      padding-left: 15px;
    }
    #workspaces button {
      color: ${yellow};
      padding-left:  5px;
      padding-right: 5px;
      margin-left: 4px;
      margin-right: 4px;
      border-bottom: ${indicator_height} solid ${background_0};
    }
    #workspaces button.empty {
      color: ${text_color};
    }
    #workspaces button.active {
      color: ${yellow};
      border-bottom: ${indicator_height} solid ${yellow};
    }

    /* Fixed center margins to isolate the clock and prevent jumping on window changes */
    #clock {
      color: ${text_color};
      border-bottom: ${indicator_height} solid ${border_color};
      margin-left: 40px;
      margin-right: 40px;
      padding-left: 10px;
      padding-right: 10px;
    }

    #tray {
      margin-left: 10px;
      margin-right: 10px;
      color: ${text_color};
    }
    #tray menu {
      background: ${background_1};
      border: 1px solid ${border_color};
      padding: 8px;
    }
    #tray menuitem {
      padding: 1px;
    }

    /* Highly compact spacing and padding for all modules to fit contents perfectly */
    #pulseaudio,
    #cpu,
    #memory,
    #disk,
    #battery,
    #custom-notification,
    #language,
    #custom-weather,
    #custom-cava,
    #window {
      padding-left: 0px;
      padding-right: 0px;
      margin-left: 4px;
      margin-right: 4px;
      color: ${text_color};
    }

    #cpu {
      border-bottom: ${indicator_height} solid ${green};
    }
    #memory {
      border-bottom: ${indicator_height} solid ${cyant};
    }
    #disk {
      border-bottom: ${indicator_height} solid ${orange};
    }

    #pulseaudio {
      border-bottom: ${indicator_height} solid ${blue};
    }
    #battery {
      border-bottom: ${indicator_height} solid ${yellow};
    }

    #custom-notification {
      border-bottom: ${indicator_height} solid ${red};
    }

    #custom-launcher {
      font-size: 20px;
      color: ${text_color};
      font-weight: bold;
      margin-left: 15px;
      padding-right: 10px;
      border-bottom: ${indicator_height} solid ${background_0};
    }

    #window {
      font-weight: bold;
      color: ${text_color};
    }
    window#waybar.empty #window {
      color: ${border_color};
    }

    /* Capitalized language module with padding zeroed out to match the exact text size */
    #language {
      border-bottom: ${indicator_height} solid ${magenta};
    }

    #custom-weather {
      border-bottom: ${indicator_height} solid ${blue};
    }

    #custom-cava {
      font-family: "monospace";
    }
  '';
}
