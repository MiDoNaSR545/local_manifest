#!/bin/bash

#####################
# Removals
#####################

rm -rf .repo/local_manifests

#####################
# Repo Init + Manifest
#####################

repo init -u https://github.com/Lunaris-AOSP/android -b test --git-lfs

git clone https://github.com/MiDoNaSR545/local_manifest --depth 1 -b main .repo/local_manifests

#####################
# Sync
#####################

if [ -f /opt/crave/resync.sh ]; then
  /opt/crave/resync.sh
else
  repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
fi

#####################
# Kernel Submodules
#####################

cd kernel/xiaomi/sm6150
git submodule update --init --recursive
cd ../../..

#####################
# Build Environment
#####################

export BUILD_USERNAME=MiDoNaSR
export BUILD_HOSTNAME=crave

source build/envsetup.sh

#####################
# Lunch + Build
#####################

lunch lineage_sweet2-bp4a-userdebug
m bacon
