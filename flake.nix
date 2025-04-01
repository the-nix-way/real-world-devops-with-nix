{
  description = "Real world DevOps with Nix";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

  outputs = inputs:
    let
      name = "todos";
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
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

      packages = forEachSupportedSystem ({ pkgs }: rec {
        default = todos;

        todos = pkgs.buildGoModule {
          name = "todos";
          src = ./.;
          subPackages = [ "cmd/todos" ];
          vendorHash = "sha256-fwJTg/HqDAI12mF1u/BlnG52yaAlaIMzsILDDZuETrI=";
        };
      });


      dockerImages = forEachSupportedSystem ({ pkgs }: {
        # A layered image means better caching and less bandwidth
        default = pkgs.dockerTools.buildLayeredImage {
          name = "lucperkins/todos";
          config = {
            Cmd = [ "${inputs.self.packages.x86_64-linux.todos}/bin/todos" ];
            ExposedPorts."8080/tcp" = { };
          };
          maxLayers = 120;
        };
      });
    };
}
