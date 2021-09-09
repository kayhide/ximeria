{ pkgs ? import <nixpkgs> {}
}:

let
  inherit (pkgs) lib stdenv;

in

stdenv.mkDerivation rec {
  pname = "ximeria";
  version = "0.1.0";

  src = ./src;

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  buildInputs = with pkgs; [
    bash
    coreutils
    yq-go
  ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/bin
    wrapProgram $out/bin/ximeria \
      --set VERSION '${version}' \
      --prefix PATH : $coreutils/bin \
      --prefix PATH : $yq-go/bin \
      --argv0 ximeria
  '';

  meta = with lib; {
    description = "Development toolkit for chimeric microservices";
    license = licenses.mit;
    maintainers = with maintainers; [ kayhide ];
  };
}
