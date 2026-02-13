# Patching jellyfin-ffmpeg to enable libvpl support
# libvpl support is required to enable qsv_av1
final: prev: {
  jellyfin-ffmpeg = prev.jellyfin-ffmpeg.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [prev.libvpl];
    configureFlags = oldAttrs.configureFlags ++ ["--enable-libvpl" "--disable-libmfx"];
  });
}
