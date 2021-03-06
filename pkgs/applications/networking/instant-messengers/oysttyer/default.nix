{ stdenv, lib, perl, perlPackages, coreutils,
fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name = "oysttyer-${version}";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner  = "oysttyer";
    repo   = "oysttyer";
    rev    = "${version}";
    sha256 = "05bfak4jr8ln4847rkj5qkazqnjym65k1phav3yicbyr3mxywhjw";
  };

  buildInputs = [
    perl
    makeWrapper
  ];

  propagatedBuildInputs = with perlPackages; [
    DateTimeFormatDateParse
    TermReadLineTTYtter
    TermReadKey
  ];

  installPhase = ''
    ${coreutils}/bin/install -Dm755 \
      oysttyer.pl \
      $out/bin/oysttyer

    wrapProgram $out/bin/oysttyer \
      --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with lib; {
    inherit version;
    description = "Perl Console Twitter Client";
    homepage    = http://oysttyer.github.io/;
    maintainers = with maintainers; [ woffs ];
    license = with licenses; [ ffsl ];
  };
}
