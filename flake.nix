{
  description = "TODOs service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore.url = "github:hercules-ci/gitignore.nix";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , gitignore
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      # Constants
      name = "todos";
      goVersion = 19;
      dockerMeta = {
        org = "lucperkins";
        image = "todos";
      };
      target = {
        os = "linux";
        arch = "amd64";
      };

      # Set up Nixpkgs
      overlays = [
        (self: super: rec {
          go = super."go_1_${toString goVersion}";
        })
      ];

      pkgs = import nixpkgs {
        inherit overlays system;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Platform-non-specific Go (for local development)
          go

          # Docker CLI
          docker

          # Kubernetes
          kubectl
          kubectx

          # Terraform
          terraform
          tflint

          # Digital Ocean
          doctl
        ];
      };

      packages = rec {
        default = todos;

        todos = pkgs.buildGoModule {
          name = "todos";
          src = gitignore.lib.gitignoreSource ./.;
          subPackages = [ "cmd/todos" ];
          vendorSha256 = "sha256-fwJTg/HqDAI12mF1u/BlnG52yaAlaIMzsILDDZuETrI=";
        };

        docker =
          pkgs.dockerTools.buildLayeredImage {
            name = "${dockerMeta.org}/${dockerMeta.image}";
            config = {
              Cmd = [ "${self.packages.${system}.default}/bin/todos" ];
              ExposedPorts."8080/tcp" = { };
            };
            maxLayers = 120;
          };
      };
    });
}
