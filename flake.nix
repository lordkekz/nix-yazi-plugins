{
  description = "A collection of plugins for the Yazi file manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake utils for stripping some boilerplate
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.4.0";
    flake-utils-plus.inputs.flake-utils.follows = "flake-utils";

    # The list of supported systems.
    systems.url = "github:nix-systems/default-linux";

    # Haumea for directory-defined attrset loading
    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils-plus,
      systems,
      haumea,
      ...
    }:
    let
      inherit (self) outputs;

      callYaziPlugins =
        pkgs:
        haumea.lib.load {
          src = ./plugins;
          inputs = {
            inherit (pkgs) lib stdenv fetchFromGitHub;
            flake = self;
          };
          # Call files like with callPackage
          loader = haumea.lib.loaders.callPackage;
          # Make the default.nix's attrs directly children of lib
          transformer = haumea.lib.transformers.liftDefault;
        };
    in
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      outputsBuilder =
        channels:
        let
          pkgs = channels.nixpkgs;
        in
        {
          packages = callYaziPlugins pkgs;
          formatter = pkgs.nixfmt-rfc-style;
        };

      overlays.default = final: prev: { yaziPlugins = callYaziPlugins prev; };
    };
}
