#!/usr/bin/env bash
set -x

[ "${BASH_VERSINFO[0]}" -ge 3 ] && set -o pipefail

GH_REPO="https://github.com/IBM-Cloud/ibm-cloud-cli-release"

TOOL_NAME="ibmcloud"
TOOL_TEST="ibmcloud"

get_platform() {
  local silent=${1:-}
  local platform=""

  platform="$(uname | tr '[:upper:]' '[:lower:]')"

  case "$platform" in
  linux | darwin | freebsd)
    # All good
    ;;
  *)
    fail "Platform '${platform}' not supported!"
    ;;
  esac

  printf "%s" "$platform"
}

get_arch() {
  local arch=""
  local arch_check=${ASDF_IBMCLOUD_OVERWRITE_ARCH:-"$(uname -m)"}
  case "${arch_check}" in
  x86_64 | amd64) arch="amd64" ;;
  i686 | i386 | 386) arch="386" ;;
  armv6l | armv7l) arch="armv6l" ;;
  aarch64 | arm64) arch="arm64" ;;
  ppc64le) arch="ppc64le" ;;
  *)
    fail "Arch '${arch_check}' not supported!"
    ;;
  esac

  printf "%s" "$arch"
}

release_file() {
  local ext
  local arch="$(get_arch)"
  local platform="$(get_platform)"

  case $platform in
  linux | freebsd)
    ext='tar.gz'
    ;;
  darwin)
    ext='pkg'
    ;;
  esac

  if [[ $(get_platform) == "darwin" ]]; then
    printf "%s" "IBM_Cloud_CLI_${ASDF_INSTALL_VERSION}.${ext}"
  else
    printf "%s" "IBM_Cloud_CLI_${ASDF_INSTALL_VERSION}_${arch}.${ext}"
  fi
}

release_url() {
  local base="https://download.clis.cloud.ibm.com/ibm-cloud-cli"

  printf "%s" "${base}/${ASDF_INSTALL_VERSION}/$(release_file)"
}

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' |
    sort_versions
}

msg() {
  echo -e "\033[32m$1\033[39m" >&2
}

err() {
  echo -e "\033[31m$1\033[39m" >&2
}

fail() {
  err "$1"
  exit 1
}
