{ stdenv, antBuild, fetchurl, unzip, perl, git, python }:

let
  version = "HEAD";

in antBuild rec {
  name = "passopolis-${version}";

  buildInputs = [ git python unzip ];
  src = fetchurl {
    url = "https://github.com/WeAreWizards/passopolis-server/archive/965d23f10ef76377e82c4a2b1ded81f4d6a28234.zip";
    sha256 = "1ij67qzwg6p3y9jwd8w68qcaricxxl5v57zq77ry4492sc6bd521";
  };
  antTargets = [ "crypto" "jar" ];

  antProperties = [
    { name = "version"; value = version; }
  ];
}
