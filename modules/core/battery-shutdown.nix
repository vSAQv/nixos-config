{...}: {
  services.upower = {
    enable = true;
    usePercentageForPolicy = true;

    percentageLow = 30;
    percentageCritical = 25;
    percentageAction = 20;

    criticalPowerAction = "PowerOff";
  };

  systemd.services.battery-emergency-shutdown = {
    description = "Emergency battery shutdown watchdog";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      TimeoutStartSec = "10s";
    };

    script = ''
      battery="/sys/class/power_supply/BAT0"
      state="/run/battery-emergency-shutdown.started"

      # Stop immediately when the battery interface is unavailable.
      [ -r "$battery/capacity" ] || exit 0
      [ -r "$battery/status" ] || exit 0

      # Treat any online Mains or USB power-supply device as external power.
      external_power=0

      for supply in /sys/class/power_supply/*; do
        [ -r "$supply/type" ] || continue
        [ -r "$supply/online" ] || continue

        type=$(cat "$supply/type")
        online=$(cat "$supply/online")

        case "$type" in
          Mains|USB)
            if [ "$online" = "1" ]; then
              external_power=1
              break
            fi
            ;;
        esac
      done

      if [ "$external_power" = "1" ]; then
        rm -f "$state"
        exit 0
      fi

      status=$(cat "$battery/status")
      capacity=$(cat "$battery/capacity")

      # Do not react to unusual battery states such as Charging or Full.
      [ "$status" = "Discharging" ] || {
        rm -f "$state"
        exit 0
      }

      # At very low charge, do not wait for the grace period.
      if [ "$capacity" -le 5 ]; then
        rm -f "$state"
        systemctl poweroff
        exit 0
      fi

      # Above the emergency threshold, there is nothing to do.
      if [ "$capacity" -gt 20 ]; then
        rm -f "$state"
        exit 0
      fi

      # Start a grace period when the battery first becomes critical.
      if [ ! -e "$state" ]; then
        date +%s > "$state"
        exit 0
      fi

      started=$(cat "$state")
      now=$(date +%s)

      # Require 60 seconds of continuous battery operation before shutdown.
      if [ "$((now - started))" -ge 60 ]; then
        rm -f "$state"
        systemctl poweroff
      fi
    '';
  };

  systemd.timers.battery-emergency-shutdown = {
    description = "Run the emergency battery shutdown watchdog periodically";

    wantedBy = ["timers.target"];

    timerConfig = {
      OnBootSec = "30s";
      OnUnitActiveSec = "15s";
      AccuracySec = "1s";
    };
  };
}
