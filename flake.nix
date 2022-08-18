{
  description = "audiosplitter";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        awk-src = builtins.readFile ./splitter.awk;
        awk-helper = pkgs.writeScript "splitter.awk" awk-src;
      in rec {
        defaultPackage = packages.audiosplitter;
        packages.audiosplitter =
          pkgs.writeShellApplication rec {
            name = "audiosplitter";
            runtimeInputs = with pkgs; [ ffmpeg parallel ];
            text = ''
            if [[ $# -ne 3 ]]; then
               echo 'Usage: ${name} TIMESTAMPS AUDIO_SOURCE OUT_DIR' >&2
               exit 1
            fi
            ${awk-helper} "$1" "$2" "$3" | parallel '';
          };
      }
        
    );
}
