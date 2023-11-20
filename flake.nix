{
  description = "Devshell and package definition";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      version = builtins.concatStringsSep "." [ "1.1.5" self.lastModifiedDate ];
    in {
      packages = {
        default = pkgs.buildGoModule rec {
          pname = "bcrypt-tool";
          inherit version;

          src = ./.;
          vendorHash = "sha256-mJkFdbWsHtA6P8/BNZXyWN5F7BJU/ImaOuZjyirub7w=";

          meta = with pkgs.lib; {
            homepage = "https://github.com/Gigahawk/bcrypt-tool";
            description = "A CLI tool for bcrypt";
            longDescription = ''
              A CLI tool for bcrypt -
              hash a password, determine if password matches a hash,
              compute cost of hash
            '';
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
      };
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          go
        ];
      };
    });
}
