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
            cat ${./example.txt} |jq -nR '[inputs] as $in | $in | [range(length) as $y | range($in[0]|length) as $x | [[0,1],[1,0],[1,1],[1,-1]] | .[] as $dir | [range(3)] | [[[$x,$y],foreach .[] as $ignored ([$x,$y]; [.[0]+$dir[0],.[1]+$dir[1]])]| .[] as [$xx,$yy] |select($yy>=0)| $in[$yy][$xx:$xx+1]]|select(all(.!=null))|join("")|select(. == "XMAS" or . == "SAMX")]|length' >$out
          '';
        };
        devShell = pkgs.mkShell {
          buildInputs = [pkgs.jq];
        };
      });
}
