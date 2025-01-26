# [Yazi](https://yazi-rs.github.io/) plugins, packaged for Nix
This is a collection of nix packages containing plugins for the Yazi TUI file manager.

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

## Branches & Compatibility
I try to support the latest release and the latest git of Yazi.
If you run the unstable version, use the `main` branch.
If you run the release version, use the corresponding branch, for example `yazi-v0.2.5`. Note that I won't delete unsupported release branches, so that your configs will still build in the future.

## Plugin list

| Attribute name | Short Description | Upstream repo |
| --- | --- | --- |
| `bypass` | Skip directories with only a single sub-directory | https://github.com/Rolv-Apneseth/bypass.yazi |
| `chmod` | Execute chmod on the selected files to change their mode | https://github.com/yazi-rs/plugins/tree/main/chmod.yazi |
| `copy-file-contents` | Copy the contents of a file to clipboard directly from Yazi | https://github.com/AnirudhG07/plugins-yazi/tree/main/copy-file-contents.yazi |
| `exifaudio` | Preview audio files metadata on yazi | https://github.com/Sonico98/exifaudio.yazi |
| `full-border` | Add a full border to Yazi to make it look fancier | https://github.com/yazi-rs/plugins/tree/main/full-border.yazi|
| `glow` | Plugin for Yazi to preview markdown files with glow | https://github.com/Reledia/glow.yazi |
| `hide-preview` | Switch the preview pane between hidden and shown | https://github.com/yazi-rs/plugins/tree/main/hide-preview.yazi |
| `jump-to-char` | Vim-like f<char>, jump to the next file whose name starts with <char> | https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi |
| `max-preview` | Maximize or restore the preview pane | https://github.com/yazi-rs/plugins/tree/main/max-preview.yazi |
| `ouch` | A Yazi plugin to preview archives | https://github.com/ndtoan96/ouch.yazi |
| `relative-motions` | basic vim motions like 3k, 12j, 10gg | https://github.com/dedukun/relative-motions.yazi |
| `rich-preview` | Rich preview plugin for yazi file manager | https://github.com/AnirudhG07/rich-preview.yazi |
| `smart-filter` | A Yazi plugin that makes filters smarter: continuous filtering, automatically enter unique directory, open file on submitting | https://github.com/yazi-rs/plugins/tree/main/smart-filter.yazi |
| `starship` | Show starship prompt in header | https://github.com/Rolv-Apneseth/starship.yazi |
| `system-clipboard` | Cross platform implementation of a simple system clipboard for yazi file manager | https://github.com/orhnk/system-clipboard.yazi |

## Contributing
To request a new plugin or an update to an existing one, you can open an issue.
Contributions are also welcome! Feel free to send PRs.

Since plugins are written in Lua, you'll most likely only need to fetch a git repo and copy the plugin content to a derivation's `$out`.
You can generate most of the code using a tool like [`nurl`](https://github.com/nix-community/nurl).
You can also take inspiration from the existing packages.
