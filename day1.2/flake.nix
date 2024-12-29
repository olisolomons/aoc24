{
  description = "Eval clojure stuff";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        repos = [ "https://repo1.maven.org/maven2/" ];
        classpath = builtins.concatStringsSep ":" [
          (pkgs.fetchMavenArtifact {
            inherit repos;
            artifactId = "clojure";
            groupId = "org.clojure";
            version = "1.12.0";
            sha256 = "sha256-xFMzAGRBoFnqn9sTQfxsH0C5IaENzNgmZTEeSKA4R2M=";
          }).jar
          (pkgs.fetchMavenArtifact {
            inherit repos;
            artifactId = "core.specs.alpha";
            groupId = "org.clojure";
            version = "0.4.74";
            sha256 = "sha256-63OsCM9JuoQMiLpnvu8RM2ylVDM9lAiAjXiUbg/rnds=";
          }).jar
          (pkgs.fetchMavenArtifact {
            inherit repos;
            artifactId = "spec.alpha";
            groupId = "org.clojure";
            version = "0.5.238";
            sha256 = "sha256-lM2ZtupjlkHzevSGCmQ7btOZ7lqL5dcXz/C2Y8jXUHc=";
          }).jar
          "src"
        ];
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
            	  ${pkgs.clojure}/bin/clojure -Scp "${classpath}" -X aoc24/part2-cli :input '"example.txt"' >$out
            	'';
        };
        devShell =
          pkgs.mkShell { buildInputs = [ pkgs.clojure pkgs.clojure-lsp ]; };
      });
}
