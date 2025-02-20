{ lib, stdenv, fetchFromGitHub, meson, ninja, nasm }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256 = "sha256-TkMy2tEdG1FPPWfH/wPnVbs5kocqe4Y0jU4yvbiRZ9k=";
  };

  sourceRoot = "source/libvmaf";

  nativeBuildInputs = [ meson ninja nasm ];

  mesonFlags = [ "-Denable_avx512=true" ];

  outputs = [ "out" "dev" ];
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Netflix/vmaf";
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    changelog = "https://github.com/Netflix/vmaf/raw/v${version}/CHANGELOG.md";
    platforms = platforms.unix;
    license = licenses.bsd2Patent;
    maintainers = [ maintainers.cfsmp3 maintainers.marsam ];
  };

}
