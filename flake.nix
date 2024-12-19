{
  description = "Eval clojure stuff";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        parts = [ ./day1.1 ./day1.2 ./day2.1 ./day2.2 ./day3.1 ./day3.2 ./day4.1 ./day4.2 ];
        results = (map (part: {
          name = builtins.baseNameOf part;
          value = ((import (part + "/flake.nix")).outputs {
            self = { };
            inherit flake-utils nixpkgs;
          }).defaultPackage.${system};
        }) parts);
        builder = ''
          export PATH=${pkgs.coreutils}/bin
          mkdir $out
          	  '' + builtins.concatStringsSep "\n" (map ({ name, value }: ''
                cp ${value} $out/${name} 
            	    	  '') results);
      in {
        defaultPackage = derivation {
          name = "aoc";
          inherit system;
          builder = pkgs.writeShellScript "builder.sh" builder;
        };
      });
}
