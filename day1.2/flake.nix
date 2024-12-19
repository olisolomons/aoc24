{
  description = "Eval clojure stuff";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = derivation {
	  name = "day1.2";
	  inherit system;
	  builder = pkgs.writeShellScript "builder.sh" ''
	  export PATH=${pkgs.coreutils}/bin
	  export HOME=$(pwd)
    cd ${./.}
	  pwd
	  ${pkgs.tree}/bin/tree
	  ${pkgs.clojure}/bin/clj -X aoc24/part2-cli :input '"example.txt"' >$out
	'';
	};
        devShell = pkgs.mkShell {
          buildInputs = [pkgs.clojure pkgs.clojure-lsp ];
        };
      }
    );
}
