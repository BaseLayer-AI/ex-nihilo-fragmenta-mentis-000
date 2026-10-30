{
  description = "Out of Nothing: Fragments of the Mind";
  inputs = { nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*"; };

  outputs = { self, nixpkgs }:
    let
      aarch64-darwin = import nixpkgs { system = "aarch64-darwin"; };
      aarch64-linux = import nixpkgs { system = "aarch64-linux"; };
      x86_64-linux = import nixpkgs { system = "x86_64-linux"; };

      readme = { pkgs } : pkgs.writeTextFile { name = "readme"; executable = true; destination = "/bin/readme";
        text = ''#!${pkgs.stdenv.shell}
cat ${self}/README.md
        '';};

      inspect-nixpkgs = { pkgs } : pkgs.writeTextFile { name = "inspect-nixpkgs"; executable = true; destination = "/bin/inspect-nixpkgs";
        text = ''#!${pkgs.stdenv.shell}
echo WARNING: THIS IS GOING TO BE MASSIVE!
echo IT IS MEANT TO BE CONSUMED BY TOOLS 🤖
echo ${nixpkgs}
ls -lR ${nixpkgs}
cat ${nixpkgs}/README.md
        '';};

      path-info = { pkgs } : pkgs.writeTextFile { name = "path-info"; executable = true; destination = "/bin/path-info";
        text = ''#!${pkgs.stdenv.shell}
nix path-info --json --json-format 1 --recursive .#default
nix path-info --json --json-format 1 --recursive .#inspect-nixpkgs
nix path-info --json --json-format 1 --recursive .#path-info
        '';};

    in {
      packages.aarch64-darwin.default = readme { pkgs = aarch64-darwin; };
      packages.aarch64-linux.default = readme { pkgs = aarch64-linux; };
      packages.x86_64-linux.default = readme { pkgs = x86_64-linux; };

      packages.aarch64-darwin.inspect-nixpkgs = inspect-nixpkgs { pkgs = aarch64-darwin; };
      packages.aarch64-linux.inspect-nixpkgs = inspect-nixpkgs { pkgs = aarch64-linux; };
      packages.x86_64-linux.inspect-nixpkgs = inspect-nixpkgs { pkgs = x86_64-linux; };

      packages.aarch64-darwin.path-info = path-info { pkgs = aarch64-darwin; };
      packages.aarch64-linux.path-info = path-info { pkgs = aarch64-linux; };
      packages.x86_64-linux.path-info = path-info { pkgs = x86_64-linux; };
    };
}

