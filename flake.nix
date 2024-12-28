{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    zephyr = {
      url = "github:zephyrproject-rtos/zephyr/v3.5.0";
      flake = false;
    };

    zephyr-nix = {
      url = "github:adisbladis/zephyr-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zephyr.follows = "zephyr";
    };

  };

  outputs =
    {
      nixpkgs,
      zephyr-nix,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      zephyr = zephyr-nix.packages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          (zephyr.sdk.override {
            targets = [
              "arm-zephyr-eabi"
            ];
          })
          zephyr.pythonEnv
          # Use zephyr.hosttools-nix to use nixpkgs built tooling instead of official Zephyr binaries
          zephyr.hosttools
          pkgs.cmake
          pkgs.ninja
        ];
      };
    };
}
