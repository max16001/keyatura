#!/usr/bin/env bash

set -euxo pipefail

# Requirements:
# 1. https://zmk.dev/docs/development/setup
# 2. checkout zmk repo to feat/pointers-move-scroll on petejohansson's repo

build_and_copy () {
    local side=$1
    west build \
        -p -b nice_nano_v2 \
        -S studio-rpc-usb-uart \
        -d "$CURRENT_DIR/build/$side" -- \
        -DZMK_CONFIG="$CURRENT_DIR" \
        -DSHIELD=keyatura_$side \
        -DZMK_EXTRA_MODULES="$HOME/zmk_modules/zmk-pmw3610-driver" \
        -DCONFIG_ZMK_STUDIO=y 

    cp "$CURRENT_DIR/build/$side/zephyr/zmk.uf2" "$CURRENT_DIR/build/$side/keyatura_$side.uf2"
}

CURRENT_DIR="$(pwd)"

DEFAULTZMKAPPDIR="$HOME/zmk/"
ZMK_APP_DIR="$DEFAULTZMKAPPDIR/app"

cd $DEFAULTZMKAPPDIR && source .venv/bin/activate && cd -

mkdir -p $CURRENT_DIR/build

pushd $ZMK_APP_DIR

# build_and_copy left
build_and_copy right

deactivate

popd
