{
  description = "Eval clojure stuff";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = derivation {
          name = "aoc";
          inherit system;
          builder = pkgs.writeShellScript "builder.sh" ''
            export PATH=${pkgs.coreutils}/bin:${pkgs.jq}/bin
            cat ${./example.txt} |jq -Rs '[match("(^|do\\(\\))((?!don'"'"'t\\(\\))(.|\\n))*";"g") | .string | match("mul\\((\\d+),(\\d+)\\)"; "g") | .captures | map(.string|tonumber)|.[0]*.[1]]|add' >$out
          '';
        };
        devShell = pkgs.mkShell {
          buildInputs = [pkgs.jq];
        };
      });
}
