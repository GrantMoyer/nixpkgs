{ stdenv, R, makeWrapper, recommendedPackages, packages }:

stdenv.mkDerivation {
  name = R.name + "-wrapper";

  buildInputs = [makeWrapper R] ++ recommendedPackages ++ packages;

  # Make the list of recommended R packages accessible to other packages such as rpy2
  passthru.recommendedPackages = recommendedPackages;

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cd ${R}/bin
    for exe in *; do
      makeWrapper ${R}/bin/$exe $out/bin/$exe \
        --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
    done
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
