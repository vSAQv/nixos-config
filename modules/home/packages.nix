{
  inputs,
  pkgs,
  ...
}: {
  home.packages = (
    with pkgs; [
      ## CLI utility
      ani-cli
      binsider
      bitwise # cli tool for bit / hex manipulation
      caligula # User-friendly, lightweight TUI for disk imaging
      cliphist # clipboard manager
      docfd # TUI multiline fuzzy document finder
      eza # ls replacement
      entr # perform action when file change
      fd # find replacement
      ffmpeg
      file # Show file information
      gtt # google translate TUI
      gifsicle # gif utility
      gtrash # rm replacement, put deleted files in system trash
      hexdump
      imv # image viewer
      killall
      lazygit
      libnotify
      man-pages # extra man pages
      mpv # video player
      ncdu # disk space
      nitch # systhem fetch util
      openssl
      onefetch # fetch utility for git repo
      pamixer # pulseaudio command line mixer
      playerctl # controller for media players
      poweralertd
      programmer-calculator
      qview # minimal image viewer
      ripgrep # grep replacement
      tdf # cli pdf viewer
      tldr
      todo # cli todo list
      toipe # typing test in the terminal
      ttyper # cli typing test
      unzip
      valgrind # c memory analyzer
      wl-clipboard # clipboard utils for wayland (wl-copy, wl-paste)
      wget
      yt-dlp-light
      xdg-utils
      xxd

      ## CLI
      cbonsai # terminal screensaver
      cmatrix
      pipes # terminal screensaver
      sl
      tty-clock # cli clock
      htop
      docker-compose
      aichat
      repomix

      ## GUI Apps
      bleachbit # cache cleaner
      nix-prefetch-github
      pavucontrol # pulseaudio volume controle (GUI)
      qalculate-gtk # calculator
      soundwireserver # pass audio to android phone
      thunderbird
      vlc
      winetricks
      wineWow64Packages.wayland
      zenity
      unetbootin
      gparted
      antigravity
      ayugram-desktop
      ludusavi

      gimp
      reaper
      audacity
      davinci-resolve
      obs-studio

      # C / C++
      gcc
      gdb
      gnumake

      # Python
      python3
      python312Packages.ipython

      # OSINT
      firefox
      mariadb
      theharvester # for sites
      photon # for sites
      ghunt # gmail
      h8mail # check for relatted emails
      holehe # check for registered sites
      sn0int

      # Funny stuff
      jp2a # to make ascii images
      ytfzf
      youtube-tui
      wiki-tui
      chess-tui
      tmux
      links2
      lshw
      anki
      wlsunset
      appimage-run
      linphone
      lmms
      darktable
      ansel

      inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
      inputs.alejandra.defaultPackage.${system}
    ]
  );
}
