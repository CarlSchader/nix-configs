{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; # Allow unfree packages like cuda
        };
      in
      {
        devShell = pkgs.mkShell rec {
          buildInputs = with pkgs; [
            python310
          ];

          shellHook = ''
            echo "activating shell"
            
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}"
            export TMPDIR=/tmp && export VENV=$(mktemp -d)
            python -m venv $VENV
            source $VENV/bin/activate

            # Python with packages
            touch requirements.txt
            pip install -r requirements.txt

            echo Done!
          '';
        };
      }
    );
}
