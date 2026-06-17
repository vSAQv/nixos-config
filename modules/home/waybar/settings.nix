{
  host,
  pkgs,
  ...
}: let
  # Self-contained Python script to fetch, handle boot delay, URL-encode locations, and output JSON weather
  weatherScript = pkgs.writeScript "waybar-weather" ''
    #!${pkgs.python3}/bin/python3
    import urllib.request
    import urllib.parse
    import json
    import sys
    import time
    from datetime import datetime

    # Wait up to 30 seconds for network connection to avoid N/A on boot
    for _ in range(15):
        try:
            with urllib.request.urlopen("http://clients3.google.com/generate_204", timeout=2) as response:
                if response.getcode() == 204:
                    break
        except Exception:
            time.sleep(2)

    # Get location via ip-api.com (100% dynamic lookup)
    city = "Polotsk"
    try:
        req = urllib.request.Request("http://ip-api.com/json", headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=3) as response:
            geo = json.loads(response.read().decode())
            if geo.get("status") == "success" and geo.get("city"):
                city = geo["city"]
    except Exception:
        pass

    # URL-encode city name to prevent control character crashes (e.g., "New York" -> "New%20York")
    encoded_city = urllib.parse.quote(city)

    # Fetch rich weather data from wttr.in in JSON format
    try:
        url = f"https://wttr.in/{encoded_city}?format=j1"
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=3) as response:
            data = json.loads(response.read().decode())

        curr = data['current_condition'][0]
        temp = curr['temp_C']
        desc = curr['weatherDesc'][0]['value']
        uv = curr['uvIndex']
        humidity = curr['humidity']
        wind = curr['windspeedKmph']

        # Symmetrical weather emoji mapping
        emoji_map = {
            "clear": "☀️", "sunny": "☀️", "partly cloudy": "⛅",
            "cloudy": "☁️", "overcast": "☁️", "mist": "🌫️",
            "fog": "🌫️", "patchy rain": "🌦️", "light rain": "🌧️",
            "moderate rain": "🌧️", "heavy rain": "🌧️", "thunderstorm": "⛈️"
        }
        emoji = "☁️"
        desc_lower = desc.lower()
        for key, val in emoji_map.items():
            if key in desc_lower:
                emoji = val
                break

        # Squeezed text format (no spaces)
        text = f"{emoji}{temp}°C"

        # Build multi-line tooltip with location verification and 3-day forecast
        tooltip = f"📍 Location: {city}\n"
        tooltip += f"🌡️ Temp: {temp}°C (Feels like {curr['FeelsLikeC']}°C)\n"
        tooltip += f"✨ Condition: {desc}\n"
        tooltip += f"☀️ UV Index: {uv}\n"
        tooltip += f"💧 Humidity: {humidity}%\n"
        tooltip += f"💨 Wind: {wind} km/h\n\n"
        tooltip += "📅 3-Day Forecast:\n"

        for day in data['weather'][:3]:
            raw_date = day['date']
            try:
                parsed_date = datetime.strptime(raw_date, "%Y-%m-%d")
                formatted_date = parsed_date.strftime("%b %d")
            except Exception:
                formatted_date = raw_date
            max_t = day['maxtempC']
            min_t = day['mintempC']
            day_desc = day['hourly'][4]['weatherDesc'][0]['value']
            day_emoji = "☁️"
            day_desc_lower = day_desc.lower()
            for key, val in emoji_map.items():
                if key in day_desc_lower:
                    day_emoji = val
                    break
            tooltip += f"  {formatted_date}: {day_emoji} {min_t}°C to {max_t}°C ({day_desc})\n"

        print(json.dumps({"text": text, "tooltip": tooltip}))
    except Exception as e:
        print(json.dumps({"text": "☁️N/A", "tooltip": f"wttr.in query failed: {str(e)}"}))
  '';

  # Raw cava frequency mapping limited to 15fps to prevent main event loop starvation
  cavaScript = pkgs.writeShellScript "waybar-cava" ''
    config_file="/tmp/waybar_cava_config"
    echo "
    [general]
    bars = 10
    framerate = 15
    [output]
    method = raw
    raw_target = /dev/stdout
    data_format = ascii
    ascii_max_range = 7
    " > "$config_file"

    ${pkgs.cava}/bin/cava -p "$config_file" | while read -r line; do
      echo "$line" | ${pkgs.gnused}/bin/sed '
        s/;//g;
        s/0/ /g;
        s/1/ /g;
        s/2/▂/g;
        s/3/▃/g;
        s/4/▄/g;
        s/5/▅/g;
        s/6/▆/g;
        s/7/▇/g;
        s/8/█/g;
      '
    done
  '';

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
  programs.waybar.settings.mainBar = with custom; {
    position = "bottom";
    layer = "top";
    height = 30;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;

    # Force absolute monitor centering for the center module box
    "fixed-center" = true;

    # Balanced left-side modules grouping
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
      "hyprland/language"
      "tray"
      "hyprland/window"
    ];

    # Center box containing clock
    modules-center = [
      "clock"
    ];

    # Balanced right-side modules grouping
    modules-right = [
      "custom/cava"
      "custom/weather"
      "cpu"
      "memory"
      (
        if (host == "desktop")
        then "disk"
        else ""
      )
      "pulseaudio"
      "battery"
      "custom/notification"
    ];

    "hyprland/window" = {
      "format" = "󰖲  {class}";
      "rewrite" = {
        "kitty" = "Terminal";
        "zen-beta" = "Zen";
        "zen-alpha" = "Zen";
        "zen" = "Zen";
        "AyuGram" = "AyuGram";
        "ayugram" = "AyuGram";
        "Spotify" = "Spotify";
        "discord" = "Discord";
        "nautilus" = "Files";
        "org.gnome.Nautilus" = "Files";
      };
      "separate-outputs" = true;
      "max-length" = 12;
      "tooltip" = false;
    };

    # Keyboard layout indicator with keyboard icon completely removed as requested
    "hyprland/language" = {
      "format" = "{}";
      "format-en" = "US";
      "format-us" = "US";
      "format-ru" = "RU";
    };

    "custom/weather" = {
      "format" = "{}";
      "return-type" = "json";
      "tooltip" = true;
      "interval" = 1800;
      "exec" = "${weatherScript}";
    };

    "custom/cava" = {
      "format" = "{}";
      "exec" = "${cavaScript}";
      "tooltip" = false;
    };

    clock = {
      calendar = {
        format = {today = "<span color='#98971A'><b>{}</b></span>";};
      };
      format = "  {:%H:%M}";
      tooltip = true;
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "  {:%d/%m}";
    };

    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "I";
        "2" = "II";
        "3" = "III";
        "4" = "IV";
        "5" = "V";
        "6" = "VI";
        "7" = "VII";
        "8" = "VIII";
        "9" = "IX";
        sort-by-number = true;
      };
      persistent-workspaces = {
        "1" = [];
        "2" = [];
        "3" = [];
        "4" = [];
        "5" = [];
      };
    };

    cpu = {
      format = "<span foreground='${green}'> </span> {usage}%";
      format-alt = "<span foreground='${green}'> </span> {avg_frequency} GHz";
      interval = 2;
      on-click-right = "kitty --override font_size=14 --title float_kitty btop";
    };

    memory = {
      format = "<span foreground='${cyant}'>󰟜 </span>{}%";
      format-alt = "<span foreground='${cyant}'>󰟜 </span>{used} GiB";
      interval = 2;
      on-click-right = "kitty --override font_size=14 --title float_kitty btop";
    };

    disk = {
      format = "<span foreground='${orange}'>󰋊 </span>{percentage_used}%";
      interval = 60;
      on-click-right = "kitty --override font_size=14 --title float_kitty btop";
    };

    tray = {
      icon-size = 20;
      spacing = 8;
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "<span foreground='${blue}'> </span> {volume}%";
      format-icons = {
        default = ["<span foreground='${blue}'> </span>"];
      };
      scroll-step = 5;
      on-click = "${pkgs.pamixer}/bin/pamixer -t";
    };

    battery = {
      format = "<span foreground='${yellow}'>{icon}</span> {capacity}%";
      format-icons = [" " " " " " " " " "];
      format-charging = "<span foreground='${yellow}'> </span>{capacity}%";
      format-full = "<span foreground='${yellow}'> </span>{capacity}%";
      format-warning = "<span foreground='${yellow}'> </span>{capacity}%";
      interval = 5;
      states = {
        warning = 20;
      };
      format-time = "{H}h {M}m";
      tooltip = true;
      tooltip-format = "{timeTo}";
      tooltip-format-charging = "Time to full: {time}";
      tooltip-format-discharging = "Remaining: {time}";
    };

    "custom/launcher" = {
      format = "";
      on-click = "rofi -show drun";
      on-click-right = "wallpaper-picker";
      tooltip = false;
    };

    "custom/notification" = {
      tooltip = false;
      format = "{icon} ";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>  <span foreground='${red}'></span>";
        none = "  <span foreground='${red}'></span>";
        dnd-notification = "<span foreground='red'><sup></sup></span>  <span foreground='${red}'></span>";
        dnd-none = "  <span foreground='${red}'></span>";
        inhibited-notification = "<span foreground='red'><sup></sup></span>  <span foreground='${red}'></span>";
        inhibited-none = "  <span foreground='${red}'></span>";
        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>  <span foreground='${red}'></span>";
        dnd-inhibited-none = "  <span foreground='${red}'></span>";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
  };
}
