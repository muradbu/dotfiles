final: prev: {
  gemini-cli-bin = prev.gemini-cli-bin.overrideAttrs (old: rec {
    version = "0.25.2";
    src = prev.fetchurl {
      url = "https://github.com/google-gemini/gemini-cli/releases/download/v${version}/gemini.js";
      hash = "sha256-k5zGtNlpW+T41DxrKexaqLinV5CzrQYepW+MKVYoS9o=";
    };
  });
}
