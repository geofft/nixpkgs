{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, pkg-config
, gpgme
, glibc
, lvm2
, btrfs-progs
}:

buildGoModule rec {
  pname = "werf";
  version = "1.2.91";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    rev = "v${version}";
    sha256 = "sha256-ZafIG4D5TvAbXbo07gFajt8orTsju1GfF9a1OR0t1Oo=";
  };
  vendorSha256 = "sha256-U4eVQR/ExAENOg2XEYM+mFXANk+basdMLEcqSHuTsh4=";
  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ gpgme ]
    ++ lib.optionals stdenv.isLinux [ glibc.static lvm2 btrfs-progs ];

  # Flags are derived from
  # https://github.com/werf/werf/blob/main/scripts/build_release_v3.sh
  ldflags = [ "-s" "-w" "-X github.com/werf/werf/pkg/werf.Version=v${version}" ]
    ++ lib.optionals stdenv.isLinux [
    "-linkmode external"
    "-extldflags=-static"
  ];
  tags = [ "dfrunmount" "dfssh" "containers_image_openpgp" ]
    ++ lib.optionals stdenv.isLinux [
    "exclude_graphdriver_devicemapper"
    "netgo"
    "no_devmapper"
    "osusergo"
    "static_build"
  ];

  subPackages = [ "cmd/werf" ];

  postInstall = ''
    installShellCompletion --cmd werf \
      --bash <($out/bin/werf completion --shell=bash) \
      --zsh <($out/bin/werf completion --shell=zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/werf/werf";
    description = "GitOps delivery tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
  };
}
