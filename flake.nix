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

      inspect-pkgs = { pkgs } : pkgs.writeTextFile { name = "inspect-pkgs"; executable = true; destination = "/bin/inspect-pkgs";
        text = ''#!${pkgs.stdenv.shell}
echo WARNING: THIS IS GOING TO BE MASSIVE!
echo ${nixpkgs}
ls -lR ${nixpkgs}
cat ${nixpkgs}/README.md
        '';};

    in {
      packages.aarch64-darwin.default = readme { pkgs = aarch64-darwin; };
      packages.aarch64-linux.default = readme { pkgs = aarch64-linux; };
      packages.x86_64-linux.default = readme { pkgs = x86_64-linux; };

      packages.aarch64-darwin.inspect-pkgs = inspect-pkgs { pkgs = aarch64-darwin; };
    };
}

