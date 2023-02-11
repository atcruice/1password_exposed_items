let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {
    overlays = [
      (final: prev: {
        bundler = prev.bundler.override { ruby = final.ruby_3_1; };
      })
    ];
  };
  mkBundlerAppDevShell = nixpkgs.callPackage (import sources.bundler-app-dev-shell) {};
in
  mkBundlerAppDevShell {
    buildInputs = [
      nixpkgs.bundler
      nixpkgs.ruby_3_1
    ];
  }
