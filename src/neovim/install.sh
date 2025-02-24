#!/bin/sh
set -e

echo "Activating feature 'neovim'"

VERSION=${VERSION:-stable}

echo "Downloading source for ${VERSION}..."

curl -sL https://github.com/neovim/neovim/releases/download/${VERSION}/nvim-linux-x86_64.tar.gz | tar -xzC /usr/local 2>&1

echo "Installing..."

if ! grep -q 'export PATH=$PATH:/usr/local/nvim-linux-x86_64/bin' ~/.profile; then
  echo "Thêm Neovim vào PATH..."
  echo 'export PATH=$PATH:/usr/local/nvim-linux-x86_64/bin' >>~/.profile
fi

# Nguồn lại profile để áp dụng thay đổi
source ~/.profile

# Xác minh cài đặt
nvim -v

