{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    clojure
    clojure-lsp
    leiningen
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        haskell.haskell
        vscodevim.vim
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "calva";
          publisher = "betterthantomorrow";
          version = "v2.0.490";
          sha256 = "sha256-pL+OgJvIK5eqE5Kr/wDeJ+2BGUT9Uj42coWSHtbPolk=";
        }
      ];
    })
  ];

  
}
