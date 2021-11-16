#!/bin/sh
lsb_release -rs

TOOLCHAIN=$(cat .swift-version)
TOOLCHAIN_BASE_URL=https://download.swift.org/development/ubuntu2004/$TOOLCHAIN

echo "Installing system dependencies 📦"
sudo apt-get install \
binutils git gnupg2 libc6-dev libcurl4 libedit2 libgcc-9-dev libpython2.7 libsqlite3-0 libstdc++-9-dev libxml2 \ 
libz3-dev pkg-config tzdata uuid-dev zlib1g-dev

if [ -d "/usr/share/swift-toolchain" ]; then
    echo "Toolchain already exists, skipping download ✅"
else
    echo "Reading toolchain version from .swift-version 📄"
    echo "Detected Swift toolchain version '$(cat .swift-version)' 📄"
    echo "TOOLCHAIN=$TOOLCHAIN" >> $GITHUB_ENV

    echo "Downloading Swift toolchain ☁️"
    wget $TOOLCHAIN_BASE_URL/$TOOLCHAIN-ubuntu20.04.tar.gz

    echo "Verifying Swift toolchain 🔑"
    wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
    wget $TOOLCHAIN_BASE_URL/$TOOLCHAIN-ubuntu20.04.tar.gz.sig
    gpg --verify $TOOLCHAIN-ubuntu20.04.tar.gz.sig

    echo "Installing Swift toolchain 💻"
    tar xzf $TOOLCHAIN-ubuntu20.04.tar.gz

    mv $TOOLCHAIN-ubuntu20.04 /usr/share/swift-toolchain
    echo "Successfully installed Swift toolchain 🎉"
fi

export PATH=/usr/share/swift-toolchain/usr/bin:${PATH} 
echo "PATH=$PATH" >> $GITHUB_ENV

swift --version
