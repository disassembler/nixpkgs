{ stdenv, fetchurl, fetchpatch, openldap, pkgconfig, nspr, nss, libkrb5
, openssl, python, popt, sasl, xmlrpc_c
}:
let
  version = "1.3.5.19";
in
stdenv.mkDerivation rec {
  name = "freeipa-${version}";
  version = "4.5.3";

  src = fetchurl {
    url = "https://releases.pagure.org/freeipa/${name}.tar.gz";
    sha256 = "06xq2vqmmav0jb4g73qxsyx9lb9gqndbdaxgg64002sgrn9qghcl";
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [
    openldap
    nspr
    nss
    libkrb5
    openssl
    python
    popt
    sasl
    xmlrpc_c
  ];

  meta = with stdenv.lib; {
    homepage = https://www.freeipa.org;
    description = "FreeIPA";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ disassembler ];
  };
}
