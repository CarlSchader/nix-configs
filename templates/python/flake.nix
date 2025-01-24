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
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Python with packages
            python313
            # poetry
            # pre-commit
            # git
          ];

          shellHook = ''
            echo "Python development environment activated!"
            
            # Create a virtual environment if it doesn't exist
            if [ ! -d .venv ]; then
              echo "Creating virtual environment..."
              python -m venv .venv
            fi
            
            # Activate the virtual environment
            source .venv/bin/activate

            touch requirements.txt
            pip install -r requirements.txt
          '';
        };
      }
    );
}
