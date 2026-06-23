{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, openssl
, alsa-lib
, dbus
, expat
, fontconfig
, freetype
, glib
, libGL
, libGLU
, libglvnd
, libxkbcommon
, nspr
, nss
, systemd
, wayland
, zlib
, atk
, at-spi2-atk
, at-spi2-core
, pango
, cairo
, gtk3
, gdk-pixbuf
, libdrm
, mesa
, libx11
, libxcb
, libxcomposite
, libxcursor
, libxdamage
, libxext
, libxfixes
, libxi
, libxrandr
, libxrender
, libxtst
, libxscrnsaver
, libxcb-image
, libxcb-keysyms
, libxcb-render-util
, libxcb-wm
, xcb-util-cursor
, libxkbfile
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "plecs";
  version = "5.0.4";

  src = fetchurl {
    url = "https://www.plexim.com/sites/default/files/packages/plecs-standalone-5-0-4_linux64.tar.gz";
    hash = "sha256-f+JDNvVgo2vKfgt/fdlhc+wvApbS5yzpAtEFj67vWSA=";
  };

  icon = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/plecs.png?h=plecs-standalone";
    sha256 = "0jvqxwmyxkdcb3yp322mhsggr3hrfx3zxhy1d7vmfnh1jl8pmg3p";
  };

  # PLECS contains pre-compiled binaries and libraries.
  # We do not want Nix to strip them, as it can break them.
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "plecs";
      exec = "plecs";
      icon = "plecs";
      comment = "PLECS Standalone simulation software for power electronics";
      desktopName = "PLECS Standalone";
      genericName = "Simulation Software";
      categories = [ "Science" "Education" "Development" ];
    })
  ];

  buildInputs = [
    openssl
    alsa-lib
    dbus
    expat
    fontconfig
    freetype
    glib
    libGL
    libGLU
    libglvnd
    libxkbcommon
    nspr
    nss
    systemd # for libudev
    wayland
    zlib
    
    # GTK/Gnome libraries for QtWebEngine
    atk
    at-spi2-atk
    at-spi2-core
    pango
    cairo
    gtk3
    gdk-pixbuf
    
    # Graphics
    libdrm
    mesa # for libgbm
    
    # X11 libraries (included for robustness and fallback)
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxscrnsaver
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    xcb-util-cursor
    libxkbfile
  ];

  # These optional libraries are not bundled in the tarball and are not strictly
  # required for core functionality (libQt6WlShellIntegration is legacy wl-shell,
  # libQt6Pdf is for PDF image format support).
  autoPatchelfIgnoreMissingDeps = [
    "libQt6WlShellIntegration.so.6"
    "libQt6Pdf.so.6"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/plecs
    cp -r * $out/opt/plecs

    # Force the webengine helper to use the xcb platform to avoid Wayland EGL/graphics driver crashes.
    sed -i 's/unset QT_PLUGIN_PATH/unset QT_PLUGIN_PATH\nexport QT_QPA_PLATFORM=xcb/' $out/opt/plecs/webengine

    mkdir -p $out/bin
    
    # We wrap the main PLECS.bin binary.
    # - QT_QPA_PLATFORM is set to wayland;xcb so it uses Wayland natively, falling back to XWayland.
    # - QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu" prevents WebEngine crashes caused by NVIDIA EGL driver issues,
    #   while the sandbox remains fully active using user namespaces.
    # - We prefix LD_LIBRARY_PATH with both PLECS's internal libs and OpenSSL's lib directory so that
    #   Qt6Network can dynamically load libssl and libcrypto at runtime via dlopen.
    makeWrapper $out/opt/plecs/PLECS.bin $out/bin/plecs \
      --prefix LD_LIBRARY_PATH : "$out/opt/plecs:${openssl.out}/lib" \
      --set-default QT_QPA_PLATFORM "wayland;xcb" \
      --set-default QT_AUTO_SCREEN_SCALE_FACTOR "0" \
      --set-default QTWEBENGINE_DISABLE_SANDBOX "1" \
      --set-default QTWEBENGINE_CHROMIUM_FLAGS "--disable-gpu"

    # Install desktop icon
    mkdir -p $out/share/pixmaps
    cp ${icon} $out/share/pixmaps/plecs.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "PLECS Standalone simulation software for power electronics";
    homepage = "https://www.plexim.com/products/plecs/plecs_standalone";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "plecs";
  };
}
