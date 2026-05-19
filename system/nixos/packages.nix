{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake

    # python-build / pyenv build dependencies
    curl # downloader used by python-build
    pkg-config # CPython configure uses pkg-config to locate libs
  ];

  # set zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  # enable docker
  virtualisation.docker.enable = true;
  virtualisation.docker.extraPackages = with pkgs; [
    docker-buildx
    docker-compose
  ];

  # enable nix-ld (for non-Nix binaries to find runtime libs)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib

      zlib.dev
      openssl.dev
      readline.dev
      bzip2.dev
      libffi.dev
      sqlite.dev
      xz.dev
      ncurses.dev
      zstd.dev
      tk.dev
      gdbm.dev
      libuuid.dev
      expat.dev
    ];
  };

  # Tell CPython's ./configure where to find headers/libs on NixOS
  # (there is no global /usr/include or /usr/lib)
  environment.variables = {
    # GCC header search path for build-time compilation
    CPATH = with pkgs;
      lib.makeSearchPathOutput "dev" "include" [
        zlib.dev
        openssl.dev
        readline.dev
        bzip2.dev
        libffi.dev
        sqlite.dev
        xz.dev
        ncurses.dev
        zstd.dev
        tk.dev
        gdbm.dev
        libuuid.dev
        expat.dev
      ];

    # GCC library search path for link-time
    LIBRARY_PATH = with pkgs;
      lib.makeSearchPath "lib" [
        zlib
        readline
        libffi
        ncurses
        tk
        tcl
        expat
      ];

    # pkg-config search path so ./configure auto-discovers deps
    PKG_CONFIG_PATH = with pkgs;
      lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
        openssl
        readline
        bzip2
        libffi
        sqlite
        xz
        ncurses
        zstd
        libuuid
        expat
      ];
  };
}
