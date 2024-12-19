{
  description = "Eval clojure stuff";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    with builtins;
      let
        pkgs = nixpkgs.legacyPackages.${system};
        input = readFile ./example.txt;
        parsed = map (line:
          let
            x = filter isString
              (split "[[:space:]]+" line);
          in {
            a = elemAt x 0;
            b = elemAt x 1;
          }) (filter
            (line: isString line && stringLength line > 0)
            (split "\n" input));
	zipped = mapAttrs (name: list: sort lessThan list) (zipAttrsWith (name: values: map fromJSON values) parsed);
	abs = x: if x>0 then x else -x;
	diffs = pkgs.lib.lists.zipListsWith (a: b: abs (a - b)) zipped.a zipped.b;
        result = toJSON (foldl' add 0 diffs);
        builder = ''
          export PATH=${pkgs.coreutils}/bin
          cp ${toFile "result" result} $out
        '';
      in {
        defaultPackage = derivation {
          name = "aoc";
          inherit system;
          builder = pkgs.writeShellScript "builder.sh" builder;
        };
      });
}
