#!/system/bin/sh

TRAVAS_PATH="/data/local/tmp/gpu_fix"

if [ -d "$TRAVAS_PATH" ]; then
    rm -rf "$TRAVAS_PATH"
fi
