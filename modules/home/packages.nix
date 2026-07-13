{
  inputs,
  pkgs,
  ...
}: {
  home.packages = (
    with pkgs; [
      ## CLI utility
      ani-cli #anime tui
      #bitwise # cli tool for bit / hex manipulation
      caligula # User-friendly, lightweight TUI for disk imaging
      cliphist # clipboard manager
      #docfd # TUI multiline fuzzy document finder
      eza # ls replacement
      entr # perform action when file change
      fd # find replacement
      ffmpeg # framework for audio and video convertion
      file # Show file information
      #gtt # google translate TUI
      #gifsicle # gif utility
      gtrash # rm replacement, put deleted files in system trash
      #hexdump
      imv # image viewer
      killall # kills process by name not by a pid
      lazygit # git tui
      libnotify # library for notificatoins
      man-pages # extra man pages
      mpv # video player
      ncdu # disk space
      nitch # systhem fetch util
      openssl
      onefetch # fetch utility for git repo
      #pamixer # pulseaudio command line mixer
      playerctl # controller for media players
      poweralertd # notification demon
      #programmer-calculator
      qview # minimal image viewer
      ripgrep # grep replacement
      tdf # cli pdf viewer
      tldr
      #todo # cli todo list
      #toipe # typing test in the terminal
      ttyper # cli typing test
      unzip
      #valgrind # c memory analyzer
      wl-clipboard # clipboard utils for wayland (wl-copy, wl-paste)
      wget # download through internet
      yt-dlp-light # youtube video downloader
      xdg-utils # bunch of scripts
      #xxd # 16 bit decoder
      repomix # file compresser for ai
      htop # nerfed btop
      ddgr
      devenv

      ## CLI
      #cbonsai # terminal screensaver
      #cmatrix
      #pipes # terminal screensaver
      #sl
      tty-clock # cli clock
      docker-compose
      sops

      ## GUI Apps
      bleachbit # cache cleaner
      nix-prefetch-github # to get github hashes
      pavucontrol # pulseaudio volume controle (GUI)
      qalculate-gtk # calculator
      #soundwireserver # pass audio to android phone
      #thunderbird # mail client
      vlc # media player
      winetricks # to download windows libraries
      wineWow64Packages.wayland
      zenity # for bash scripts
      unetbootin # creation of bootloader's
      gparted # partitioning
      antigravity # IDE with free claude and latest gemini
      ayugram-desktop # better telegram
      ludusavi # for homelab steam
      #lmms # audio stuff
      #firefox
      rustdesk

      #darktable # photo edit
      #ansel # photo edit

      #gimp #photoshop alternative
      reaper # fl studio
      audacity #simple audio record
      davinci-resolve
      obs-studio

      # C / C++
      #gcc
      #gdb
      #gnumake

      # Python
      python3
      python312Packages.ipython

      # OSINT
      #mariadb
      #theharvester # for sites
      #photon # for sites
      #ghunt # gmail
      #h8mail # check for relatted emails
      #holehe # check for registered sites
      #sn0int

      # Funny stuff
      jp2a # to make ascii images
      ytfzf
      youtube-tui
      wiki-tui
      chess-tui
      #tmux #split terminal
      links2
      lshw
      anki
      wlsunset
      appimage-run

      inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
      inputs.alejandra.defaultPackage.${system}
    ]
  );
}
