#!/bin/sh
set -e

install_debian_dependencies() {
  apt-get update -y
  apt-get -y install curl
  apt-get -y clean
  rm -rf /var/lib/apt/lists/*
}

VERSION=${VERSION:-stable}

echo "Activating feature 'neovim' ${VERSION}"

if [ "$(id -u)" -ne 0 ]; then
  echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi
# Bring in ID, ID_LIKE, VERSION_ID, VERSION_CODENAME
. /etc/os-release
# Get an adjusted ID independent of distro variants
if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
  ADJUSTED_ID="debian"
  # other distros to be implemented
  # elif [[ "${ID}" = "rhel" || "${ID}" = "fedora" || "${ID}" = "mariner" || "${ID_LIKE}" = *"rhel"* || "${ID_LIKE}" = *"fedora"* || "${ID_LIKE}" = *"mariner"* ]]; then
  # todo
  # elif [ "${ID}" = "alpine" ]; then
  # todo
else
  echo "Linux distro ${ID} not supported."
  exit 1
fi

# Install packages for appropriate OS
case "${ADJUSTED_ID}" in
"debian")
  install_debian_dependencies
  ;;
esac

echo "Downloading source for ${VERSION}..."

curl -L https://github.com/neovim/neovim/releases/download/${VERSION}/nvim-linux-x86_64.tar.gz -o /tmp/nvim-linux-x86_64.tar.gz

echo "Extracting..."

tar -C /usr/local -xzf /tmp/nvim-linux-x86_64.tar.gz

echo "Installing..."

if ! grep -q 'export PATH=$PATH:/usr/local/nvim-linux-x86_64/bin' ~/.profile; then
  echo "Thêm Neovim vào PATH..."
  echo 'export PATH=$PATH:/usr/local/nvim-linux-x86_64/bin' >>~/.profile
fi

# Nguồn lại profile để áp dụng thay đổi
source ~/.profile

# Xác minh cài đặt
nvim -v

rm /tmp/nvim-linux-x86_64.tar.gz

