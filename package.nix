{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "simple-go-webserver";
  # this package has no tags
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "nerdrobot";
    repo = pname;
    rev = "74821d65afc59816a874cee5e390e80b228484b2";
    hash = "sha256-rRBHGT9rgdf5kGsLvhCJF4yJaEq4AVAg9I7PySxNvi0=";
  };

  vendorHash = "sha256-sGSBPztiLa0Ngq8zHIZUoqeQJ0CYivDcJl5/fnhZ/+0=";

  doCheck = false;

  meta = with lib; {
    description = "Simple go webserver";
    homepage = "https://github.com/devangtomar/simple-go-webserver";
    mainProgram = "simple-rest-api";
  };
}
