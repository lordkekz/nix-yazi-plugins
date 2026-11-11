# [Yazi](https://yazi-rs.github.io/) plugins, packaged for Nix
This is a collection of nix packages containing plugins for the Yazi TUI file manager.

## Upstream Packages
Quite Recently NixOS added yaziPlugins upstream. For this reason some packages were removed.
The Home-Manager Integration (see below) prefers the upstream over this repositories packages, as it is assumed that nixpkgs is more stable

## Usage
In your `flake.nix`, add an input like so:
```nix
{
  inputs.nix-yazi-plugins = {
    url = "github:lordkekz/nix-yazi-plugins?ref=yazi-v0.2.5";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ...
}
```

You can use `nix flake show github:lordkekz/nix-yazi-plugins` or `nix search github:lordkekz/nix-yazi-plugins ^` to see the provided packages.
There's also an overlay which will give you the packages under `pkgs.yaziPlugins.<plugin-name>`.

The plugin packages provided by this flake can be used with the home-manager module for Yazi, see [`programs.yazi.plugins`](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.plugins).

### Home Manager Integration
> [!NOTE]
> for some plugins only packages are available. just use
> ```programs.yazi.plugins = with pkgs.yaziPlugins; {inherit pluginname;}; ```
> Note that this will not add runtime dependencies or require the plugins in Yazi's init.lua (which is not always needed)

Easily enable plugins, a sensible default is already preconfigured.
The init.lua, your keymaps, dependencies, plugins directory, ... are automatically managed for you
example usage inside home-manager:
```nix
  imports = [
    (inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default)
  ];

  programs.yazi = {
    enable = true;
  };

  programs.yazi.yaziPlugins = {
    enable = true;
    plugins = {
      starship.enable = true;
      jump-to-char = {
        enable = true;
        keys.toggle.on = [ "F" ];
      };
      relative-motions = {
        enable = true;
        show_numbers = "relative_absolute";
        show_motion = true;
      };
    };
  };
```

### nix-wrapper-modules

The flake also exports `wrapperModules.yaziWithPlugins`. It extends the
original `nix-wrapper-modules` Yazi wrapper, retaining its configuration
options while adding plugin enablement and Home-Manager-style plugin settings.
Add `nix-wrapper-modules` to your flake inputs:

```nix
{
  inputs = {
    nix-wrapper-modules = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins?ref=yazi-v0.2.5";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-wrapper-modules.follows = "nix-wrapper-modules";
    };
  };

  outputs = { self, nixpkgs, nix-wrapper-modules, nix-yazi-plugins, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.yazi = nix-wrapper-modules.lib.evalPackage [
        { inherit pkgs; }
        nix-yazi-plugins.wrapperModules.yaziWithPlugins
        {
          yaziPlugins = {
            starship.enable = true;
            relative-motions = {
              enable = true;
              show_numbers = "relative_absolute";
              show_motion = true;
            };
          };
        }
      ];
    };
}
```

The `yaziPlugins.<name>` options — including plugin-specific settings and
keymaps — are shared with the Home Manager modules. The original wrapper's
`plugins` option remains available for adding packages directly, along with its
settings, flavors, and other configuration options. The wrapper sets
`YAZI_CONFIG_HOME` to its generated, read-only configuration directory. For
plugins that save persistent data under a home directory, `$HOME` is expanded
at runtime by default; set `homeDirectory` to override it.

## Branches & Compatibility
I try to support the latest release and the latest git of Yazi.
If you run the unstable version, use the `main` branch.
If you run the release version, use the corresponding branch, for example `yazi-v0.2.5`. Note that I won't delete unsupported release branches, so that your configs will still build in the future.

## Plugin list

| Attribute name | Short Description | Upstream repo |
| --- | --- | --- |
| `bookmarks` | A Yazi plugin that adds the basic functionality of vi-like marks | https://github.com/dedukun/bookmarks.yazi |
| `bypass` | Skip directories with only a single sub-directory | https://github.com/Rolv-Apneseth/bypass.yazi |
| `chmod` | Execute chmod on the selected files to change their mode | https://github.com/yazi-rs/plugins/tree/main/chmod.yazi |
| `copy-file-contents` | Copy the contents of a file to clipboard directly from Yazi | https://github.com/AnirudhG07/plugins-yazi/tree/main/copy-file-contents.yazi |
| `exifaudio` | Preview audio files metadata on yazi | https://github.com/Sonico98/exifaudio.yazi |
| `full-border` | Add a full border to Yazi to make it look fancier | https://github.com/yazi-rs/plugins/tree/main/full-border.yazi|
| `git` | Show the status of Git file changes as linemode in the file list | https://github.com/yazi-rs/plugins/tree/main/git.yazi|
| `glow` | Plugin for Yazi to preview markdown files with glow | https://github.com/Reledia/glow.yazi |
| `jump-to-char` | Vim-like f<char>, jump to the next file whose name starts with <char> | https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi |
| `open-with-cmd` | This is a Yazi plugin for opening files with a prompted command. | https://github.com/Ape/open-with-cmd.yazi |
| `ouch` | A Yazi plugin to preview archives | https://github.com/ndtoan96/ouch.yazi |
| `recycle-bin` | Comprehensive trash management for Yazi with browse, restore, and delete capabilities | https://github.com/uhs-robert/recycle-bin.yazi |
| `relative-motions` | basic vim motions like 3k, 12j, 10gg | https://github.com/dedukun/relative-motions.yazi |
| `rich-preview` | Rich preview plugin for yazi file manager | https://github.com/AnirudhG07/rich-preview.yazi |
| `smart-enter` | Open files or enter directories all in one key! | https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi |
| `smart-filter` | A Yazi plugin that makes filters smarter: continuous filtering, automatically enter unique directory, open file on submitting | https://github.com/yazi-rs/plugins/tree/main/smart-filter.yazi |
| `starship` | Show starship prompt in header | https://github.com/Rolv-Apneseth/starship.yazi |
| `system-clipboard` | Cross platform implementation of a simple system clipboard for yazi file manager | https://github.com/orhnk/system-clipboard.yazi |
| `toggle-pane` | Toggle the show, hide, and maximize states for different panes | https://github.com/yazi-rs/plugins/tree/main/toggle-pane.yazi |
| `torrent-preview` | A Yazi plugin for previewing BitTorrent files | https://github.com/kirasok/torrent-preview.yazi |
| `whossh` |A lightning-fast, keyboard-first bookmark manager for Yazi| https://gitlab.com/WhoSowSee/whoosh.yazi |

## Contributing
To request a new plugin or an update to an existing one, you can open an issue.
Contributions are also welcome! Feel free to send PRs.

Since plugins are written in Lua, you'll most likely only need to fetch a git repo and copy the plugin content to a derivation's `$out`.
You can generate most of the code using a tool like [`nurl`](https://github.com/nix-community/nurl).
You can also take inspiration from the existing packages.

### Updating

packages can easily be updated using:
```bash
nix-update $plugin --flake --version=branch
```

or simply running
```bash
  nix run .#update -- $plugin
```
for updating all and commiting each step run
```bash
  nix run .#update-all-commit
```
