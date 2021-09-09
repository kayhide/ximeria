{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    bash
    coreutils
    yq-go

    entr
    findutils
    gnumake
    shunit2
  ];
}
