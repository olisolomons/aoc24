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
            cat ${./example.txt} |jq -nR '[inputs | split(" ") | map(tonumber) as $x | [$x[:-1],$x[1:]] | transpose | map(.[0] - .[1]) | select((map(abs) | (min | .>0) and (max | .<4)) and ([.[]|select(.!=0)] | map({key: (.>0|tostring), value: null}) | from_entries|keys|length<2))] | length' >$out
          '';
        };
        devShell = pkgs.mkShell {
          buildInputs = [pkgs.jq];
        };
      });
}
