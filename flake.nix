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
    systems.url = "github:nix-systems/default";

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
      instantiate_lib = lib: pkgs: rec {
        inherit (pkgs) callPackage;
        inherit (lib)
          mapAttrs
          mapAttrsToList
          listToAttrs
          filterAttrs
          mkMerge
          attrValues
          filter
          flatten
          attrByPath
          mkOption
          mkEnableOption
          ;
        # bypass.package = ...
        # -> bypass = ...
        CondRaiseAttrs = n: set: mapAttrs (_n: v: v."${n}") (filterAttrs (_n: v: v ? "${n}") set);

        packages = if (pkgs ? yaziPlugins) then pkgs.yaziPlugins // packagesOurs else packagesOurs;
        packagesOurs = (CondRaiseAttrs "package" YaziPlugins);

        homeManagerModulesRaised = (CondRaiseAttrs "hm-module" YaziPlugins);
        homeManagerModulesImports = (
          map (
            v:
            { config, lib, ... }:
            let
              cfg = config.programs.yazi.yaziPlugins.plugins.${v.name};
              mkModuleArg =
                args:
                (import ./lib.nix {
                  baseOptionPath = [
                    "programs"
                    "yazi"
                    "yaziPlugins"
                    "plugins"
                    v.name
                  ];
                } args)
                // {
                  inherit cfg;
                };
            in
            {
              imports = (
                filter (v: v != { }) [
                  (
                    { pkgs, ... }@args:
                    lib.mkIf (cfg.enable && args.config.programs.yazi.yaziPlugins.enable) (
                      v.config (mkModuleArg args) args
                    )
                  )
                  (_: {
                    config = lib.mkIf (cfg.enable && cfg.package != null) {
                      programs.yazi.plugins.${v.name} = cfg.package;
                    };
                  })
                  (_: {
                    config = lib.mkIf (cfg.enable && cfg ? "runtimeDeps") {
                      programs.yazi.yaziPlugins.runtimeDeps = cfg.runtimeDeps;
                    };
                  })
                  (_: {
                    config = lib.mkIf (cfg.enable && cfg ? "require") {
                      programs.yazi.yaziPlugins.require = cfg.require;
                    };
                  })
                  (_: {
                    config = lib.mkIf (cfg.enable && cfg ? "preRequire") {
                      programs.yazi.yaziPlugins.preRequire = cfg.preRequire;
                    };
                  })
                  (_: {
                    config = lib.mkIf (cfg.enable && cfg ? "postRequire") {
                      programs.yazi.yaziPlugins.postRequire = cfg.postRequire;
                    };
                  })
                  (_: {
                    config = lib.mkIf (cfg.enable && cfg ? "extraConfig" && cfg.extraConfig != "") {
                      programs.yazi.yaziPlugins.extraConfig = cfg.extraConfig;
                    };
                  })
                  ({ pkgs, ... }@args: v.options (mkModuleArg args) args)
                  (
                    { pkgs, ... }:
                    {
                      options.programs.yazi.yaziPlugins.plugins.${v.name} = {
                        package = mkOption {
                          type = lib.types.nullOr lib.types.package;
                          description = "The ${v.name} package to use";
                          #TODO document this
                          #default = (pkgs.yaziPlugins.${v.name} or self.packages.${pkgs.system}.${v.name});
                          default =
                            inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.yaziPlugins.${v.name}
                              or self.packages.${pkgs.stdenv.hostPlatform.system}.${v.name};
                        };
                        enable = mkEnableOption v.name;
                        extraConfig = mkOption {
                          type = lib.types.lines;
                          description = "Extra configuration lines to add to ~/.config/yazi/init.lua for ${v.name}";
                          default = '''';
                        };
                      };
                    }
                  )
                ]
              );
            }
          ) (attrValues homeManagerModulesRaised)
        );

        YaziPlugins =
          let
            AttrName = path: builtins.baseNameOf (builtins.dirOf path);
          in
          haumea.lib.load {
            src = ./plugins;
            inputs =
              (removeAttrs pkgs [
                "self"
                "super"
                "root"
              ])
              // {
                flake = self;
              };
            # Call files like with callPackage
            loader = [
              {
                matches = str: str == "package.nix";
                loader = inputs: path: (haumea.lib.loaders.callPackage inputs path);
              }
              {
                matches = str: str == "hm-module.nix";
                loader =
                  _: path:
                  let
                    value = haumea.lib.loaders.verbatim { } path;
                    name = AttrName path;
                  in
                  {
                    inherit name;
                    options =
                      if value ? "options" then
                        (outer_inputs: inputs: {
                          options.programs.yazi.yaziPlugins.plugins.${name} = value.options outer_inputs inputs;
                        })
                      else
                        _: _: { };
                    config = if value ? "config" then value.config else _: _: { };
                  };
              }
            ];
          };
      };

    in
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      outputsBuilder =
        channels:
        let
          pkgs = channels.nixpkgs;
          lib = inputs.nixpkgs.lib;
          instance = (instantiate_lib lib pkgs);
          inherit (instance) packages;
        in
        {
          formatter = pkgs.nixfmt-tree;
          packages = packages // {
            update = pkgs.writeShellScriptBin "update" ''
              ${lib.getExe pkgs.nix-update} $1 --flake --version=branch
            '';
            # this package definition was generated using Claude Sonnet 5 Medium
            update-all-commit = pkgs.writeShellScriptBin "update-all-commit" ''
              set -uo pipefail

              root="$(${lib.getExe pkgs.git} rev-parse --show-toplevel)"
              cd "$root"

              system="$(${lib.getExe pkgs.nix} eval --raw --impure --expr builtins.currentSystem)"

              for dir in plugins/*/; do
                plugin="$(basename "$dir")"
                pkg_file="plugins/$plugin/package.nix"

                if [ ! -f "$pkg_file" ]; then
                  echo "skip $plugin (no $pkg_file)"
                  continue
                fi

                old_rev="$(${lib.getExe pkgs.nix} eval --raw ".#packages.$system.$plugin.src.rev" 2>/dev/null)"
                if [ -z "$old_rev" ]; then
                  echo "skip $plugin (couldn't eval src.rev, currently broken?)"
                  continue
                fi

                if ! ${lib.getExe pkgs.nix-update} "$plugin" --flake --version=branch; then
                  echo "skip $plugin (nix-update failed)"
                  ${lib.getExe pkgs.git} checkout -- "$pkg_file"
                  continue
                fi

                if ${lib.getExe pkgs.git} diff --quiet -- "$pkg_file"; then
                  echo "up to date: $plugin"
                  continue
                fi

                new_rev="$(${lib.getExe pkgs.nix} eval --raw ".#packages.$system.$plugin.src.rev")"

                ${lib.getExe pkgs.git} add "$pkg_file"
                ${lib.getExe pkgs.git} commit -m "feat($plugin): update package from ''${old_rev:0:7} to ''${new_rev:0:7}"
              done
            '';
          };
          legacyPackages = {
            homeManagerModules = rec {
              yaziPlugins =
                { lib, ... }:
                {
                  imports =
                    ((instantiate_lib lib (inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system})).homeManagerModulesImports)
                    ++ [ ./module.nix ];
                };
              default = yaziPlugins;
            };
          };

        };

      overlays.default = final: prev: { yaziPlugins = (instantiate_lib (final.lib) prev).packages; };

    };
}
