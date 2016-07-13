{ mkDerivation
, stdenv
, base
, directory
, filepath
, optparse-applicative
, pipes
, pipes-safe
, unix
, tasty
, tasty-hunit
, tasty-quickcheck
, tasty-th
, temporary
, dns
}:
mkDerivation {
  pname = "admin-lib";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base
    directory
    filepath
    optparse-applicative
    pipes
    pipes-safe
    unix
    dns
  ];
  testHaskellDepends = [
    tasty
    tasty-hunit
    tasty-quickcheck
    tasty-th
    temporary
  ];
  description = "";
  license = "";
}
