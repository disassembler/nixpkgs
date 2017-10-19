{ stdenv, fetchFromGitHub, autoreconfHook
}:
stdenv.mkDerivation rec {
  name = "ding-libs-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "SSSD";
    repo = "ding-libs";
    rev = "ding_libs-0_4_0";
    sha256 = "179963lwc99rp1wrvsdwvfda2avwhg8zfsv3x2li2p13cc5j383k";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];
  buildInputs = [
  ];

  meta = with stdenv.lib; {
    homepage = https://www.freeipa.org;
    description = "FreeIPA";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ disassembler ];
  };
}
