{ mkDerivation
, stdenv
, attoparsec
, base
, bytestring
, dns
, lens
, MissingH
, transformers
, optparse-applicative
, pipes
, pipes-bytestring
, tasty
, tasty-hunit
, tasty-th
}:
mkDerivation {
  pname = "spf-ips";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    attoparsec
    base
    bytestring
    dns
    lens
    MissingH
    optparse-applicative
    pipes
    pipes-bytestring
    transformers
  ];
  testHaskellDepends = [
    tasty
    tasty-hunit
    tasty-th
  ];
  description = "";
  license = "";
}
