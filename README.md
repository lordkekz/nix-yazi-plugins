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

## Branches & Compatibility
I try to support the latest release and the latest git of Yazi.
If you run the unstable version, use the `main` branch.
If you run the release version, use the corresponding branch, for example `yazi-v0.2.5`. Note that I won't delete unsupported release branches, so that your configs will still build in the future.

## Plugin list

| Attribute name | Short Description | Upstream repo |
| --- | --- | --- |
| `bypass` | Skip directories with only a single sub-directory | https://github.com/Rolv-Apneseth/bypass.yazi |
| `relative-motions` | basic vim motions like 3k, 12j, 10gg | https://github.com/dedukun/relative-motions.yazi |
| `starship` | Show starship prompt in header | https://github.com/Rolv-Apneseth/starship.yazi |
| `fg` | Search by file content or by filenames using ripgrep or ripgrep-all with fzf preview. Details in [plugins/fg/README.md]. | https://github.com/lpnh/fg.yazi |

## Contributing
To request a new plugin or an update to an existing one, you can open an issue.
Contributions are also welcome! Feel free to send PRs.

Since plugins are written in Lua, you'll most likely only need to fetch a git repo and copy the plugin content to a derivation's `$out`.
You can generate most of the code using a tool like [`nurl`](https://github.com/nix-community/nurl).
You can also take inspiration from the existing packages.
