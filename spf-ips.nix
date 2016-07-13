{ mkDerivation
, stdenv
, attoparsec
, base
, bytestring
, directory
, filepath
, transformers
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
, lens
}:
mkDerivation {
  pname = "admin-lib";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    attoparsec
    base
    bytestring
    directory
    filepath
    optparse-applicative
    pipes
    pipes-safe
    transformers
    unix
    dns
    lens
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
