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
            cat ${./example.txt} |jq -nR '[inputs] as $in | $in | [range(length-2) as $y | range($in[0]|length-2) as $x | [[[$x,$y],[$x+1,$y+1],[$x+2,$y+2]],[[$x+2,$y],[$x+1,$y+1],[$x,$y+2]]]|map(map($in[.[0]][.[1]:.[1]+1])|join(""))|select(.[0]=="MAS" or .[0]=="SAM")|select(.[1]=="MAS" or .[1]=="SAM")]|length' >$out
          '';
        };
        devShell = pkgs.mkShell {
          buildInputs = [pkgs.jq];
        };
      });
}
