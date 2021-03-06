{ stdenv, buildPythonPackage, fetchFromGitHub, pkgs, qtbase, qmake, soqt }:

buildPythonPackage rec {
  pname = "pivy";
  version = "0.6.5a2";

  src = fetchFromGitHub {
    owner = "FreeCAD";
    repo = "pivy";
    rev = version;
    sha256 = "1w03jaha36bjyfaz8hchnv8yrkm5715w15crhd3qrlagz8fs38hm";
  };

  nativeBuildInputs = with pkgs; [
    swig qmake cmake
  ];

  buildInputs = with pkgs; with xorg; [
    coin3d soqt qtbase
    libGLU libGL
    libXi libXext libSM libICE libX11
  ];

  NIX_CFLAGS_COMPILE = toString [
    "-I${qtbase.dev}/include/QtCore"
    "-I${qtbase.dev}/include/QtGui"
    "-I${qtbase.dev}/include/QtOpenGL"
    "-I${qtbase.dev}/include/QtWidgets"
  ];

  dontUseQmakeConfigure = true;
  dontUseCmakeConfigure = true;

  doCheck = false;

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace \$'{SoQt_INCLUDE_DIRS}' \
      \$'{Coin_INCLUDE_DIR}'\;\$'{SoQt_INCLUDE_DIRS}'
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/coin3d/pivy/";
    description = "A Python binding for Coin";
    license = licenses.bsd0;
    maintainers = with maintainers; [ gebner ];
  };

}
