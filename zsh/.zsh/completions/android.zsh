#!/bin/zsh
# Android SDK — only wire up if the SDK is present
if [[ -d "$HOME/android" ]]; then
    export ANDROID_HOME="$HOME/android"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    path=(
        "$ANDROID_HOME/cmdline-tools/latest/bin"
        "$ANDROID_HOME/platform-tools"
        "$ANDROID_HOME/tools"
        "$ANDROID_HOME/tools/bin"
        $path
    )
fi
