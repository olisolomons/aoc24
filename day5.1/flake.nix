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
            cat ${./example.txt} |jq -nR '[inputs]|join("\n")|split("\n\n")|map(split("\n"))|[(.[0]|map(split("|"))|reduce .[] as [$a,$b] ({}; .[$a][$b]=true)),(.[1]|map(split(",")))] as [$m,$p]|[$p[]|select(label $out | reduce .[] as $page ([]; if any($m[$page][.]) then break $out else .+=[$page] end))|.[(length-1)/2]|tonumber]|add' >$out
          '';
        };
        devShell = pkgs.mkShell {
          buildInputs = [pkgs.jq];
        };
      });
}
