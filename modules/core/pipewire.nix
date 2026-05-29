{ pkgs, ... }:
{
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          # Ограничиваем кодеки, ставим LDAC в приоритет
          "bluez5.codecs" = [ "ldac" ];
        };
      };
    };
    # lowLatency.enable = true;
    extraConfig.pipewire."92-audiophile" = {
      "context.properties" = {
        # Разрешаем PipeWire менять частоту в зависимости от исходного файла
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          192000
        ];
        "default.clock.rate" = 44100;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
      };
      "stream.properties" = {
        # Максимальное качество ресемплера (Speex)
        "resample.quality" = 10;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    pavucontrol
    strawberry
  ];
}
