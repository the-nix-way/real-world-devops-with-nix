{
  description = "Real world DevOps with Nix";

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

    let
      name = "todos";
      goVersion = 19;
      # An overlay to set the Go version
      goOverlay = self: super: {
        go = super."go_1_${toString goVersion}";
      };
      overlays = [ goOverlay ];
    in
    # The package and Docker image are only intended to be built on amd64 Linux
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
      let
        pkgs = import nixpkgs { inherit overlays system; };
        dockerMeta = {
          org = "lucperkins";
          image = "todos";
        };
      in
      {
        packages = rec {
          default = todos;

          todos = pkgs.buildGoModule {
            name = "todos";
            src = gitignore.lib.gitignoreSource ./.;
            subPackages = [ "cmd/todos" ];
            vendorSha256 = "sha256-fwJTg/HqDAI12mF1u/BlnG52yaAlaIMzsILDDZuETrI=";
          };

          docker =
            # A layered image means better caching and less bandwidth
            pkgs.dockerTools.buildLayeredImage {
              name = "${dockerMeta.org}/${dockerMeta.image}";
              config = {
                Cmd = [ "${self.packages.${system}.todos}/bin/todos" ];
                ExposedPorts."8080/tcp" = { };
              };
              maxLayers = 120;
            };
        };
      }) //
    # The shell environment is intended for all systems
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit overlays system;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs;
          [
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
    });
}
