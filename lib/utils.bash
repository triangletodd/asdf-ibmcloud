#!/usr/bin/env bash
TOOL_NAME="ibmcloud"
TOOL_TEST="ibmcloud"

HOST="download.clis.cloud.ibm.com"
METADATA_HOST="$HOST/ibm-cloud-cli-metadata"
BINARY_DOWNLOAD_HOST="$HOST/ibm-cloud-cli"
OS_NAME=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "$OS_NAME" = "linux" ]; then
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')
    if echo "$ARCH" | grep -q 'x86_64'
    then
        PLATFORM="linux64"
    elif echo "$ARCH" | grep -q -E '(x86)|(i686)'
    then
        PLATFORM="linux32"
    elif echo "$ARCH" | grep -q 'ppc64le'
    then
        PLATFORM="ppc64le"
    elif echo "$ARCH" | grep -q 's390x'
    then
        PLATFORM="s390x"
    elif echo "$ARCH" | grep -q 'arm64'
    then
        PLATFORM="linux-arm64"
    elif echo "$ARCH" | grep -q 'aarch64'
    then
        PLATFORM="linux-arm64"
    else
        echo "Unsupported Linux architecture: ${ARCH}. Quit installation."
        exit 1
    fi
else
    echo "Unsupported platform: ${OS_NAME}. Quit installation."
    exit 1
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

# fetch version metadata of CLI
raw_info() {
    local endpoint="https://$METADATA_HOST/info.json"
    local info=$(curl -f -L -s "$endpoint")
    local status="$?"

    if [ $status -ne 0 ];
    then
        echo "Download latest CLI metadata failed. Please check your network connection. Quit installation."
        exit 1
    fi
    echo ${info}
}

# fetch all versions metadata of CLI
raw_all_versions() {
    local endpoint="https://$METADATA_HOST/all_versions.json"
    local all_versions=$(curl -f -L -s "$endpoint")
    status="$?"
    if [ $status -ne 0 ];
    then
        echo "Download latest CLI versions metadata failed. Please check your network connection. Quit installation."
        exit 1
    fi

    echo ${all_versions}
}

# get the section of the metadata that we need, starting from the matching version text to the text 'archives'
raw_metadata_section() {
    local version="$1"

    local metadata_section=$(raw_all_versions | sed -ne '/'\""$version"\"'/,/'"archives"'/p')
    if [ -z "$metadata_section" ]
    then
        echo "Unable to parse metadata for CLI version $version. Quit installation."
        exit 1
    fi

    echo ${metadata_section}
}

# get the section for the appropriate platform
platform_binaries() {
    local version="$1"

    raw_metadata_section "$1" | sed -ne '/'"$PLATFORM"'/,/'"checksum"'/p'
}

# get the installer url
installer_url() {
    local version="$1"

    platform_binaries "$1" | grep -Eo '"url"[^,]*' | cut -d ":" -f2- | tr -d '"' | tr -d '[:space:]'
}

# get the checksum
sh1sum() {
    local version="$1"

    platform_binaries "$1" | grep -Eo '"checksum"[^,]*' | cut -d ":" -f2- | tr -d '"' | tr -d '[:space:]'
}

list_all_versions() {
    raw_all_versions | grep -Eo '"version"[^,]*' | cut -d ":" -f2- | tr -d '"' | sed 's/^ //' | sort_versions
}

latest_version() {
    raw_info | grep -Eo '"latestVersion"[^,]*' | grep -Eo '[^:]*$' | tr -d '"' | tr -d '[:space:]'
}

download_release() {
    local version="$1"
    local filename="$2"

    local url=$(installer_url "$version")

    echo "* Downloading $TOOL_NAME release $version..."
    curl -fsSL ${url} -o "${filename}" -C - "$url" || fail "Could not download $url"
}

install_version() {
    local install_type="$1"
    local version="$2"
    local install_path="${3%/bin}/bin"

    if [ "$install_type" != "version" ]; then
        fail "asdf-$TOOL_NAME supports release installs only"
    fi

    (
        mkdir -p "$install_path"
        cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

        local tool_cmd
        tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
        test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

        echo "$TOOL_NAME $version installation was successful!"
    ) || (
        rm -rf "$install_path"
        fail "An error occurred while installing $TOOL_NAME $version."
    )
}

  #calculated_sha1sum=$(sha1sum /tmp/${file_name} | awk '{print $1}')
  #if [ "$sh1sum" != "$calculated_sha1sum" ]; then
      #echo "Downloaded file is corrupted. Quit installation."
      #exit 1
  #fi
  #cd /tmp || exit
  #tar -xvf /tmp/${file_name}
  #chmod 755 /tmp/Bluemix_CLI/install
  #/tmp/Bluemix_CLI/install -q
  #install_result=$?
  #rm -rf /tmp/Bluemix_CLI
#
  #if [ $install_result -eq 0 ] ; then
      #echo "Install complete."
  #else
      #echo "Install failed."
  #fi
  #rm /tmp/${file_name}
#
