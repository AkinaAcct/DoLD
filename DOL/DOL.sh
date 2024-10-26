#!/usr/bin/env bash
# By Akina
# WARN: WIP

DOWNLINKS="$(curl -sL https://api.github.com/repos/Lyoko-Jeremie/DoLModLoaderBuild/releases/latest | jq -r .assets[].browser_download_url | grep DoL-ModLoader)"
msg_info "Downloading... Url: ${DOWNLINKS}"
curl --progress-bar -L "${DOWNLINKS}" -o ${WORKDIR}/dol.zip
unzip ${WORKDIR}/dol.zip -d "${HOME}/.DOL"
mv "${HOME}/.DOL/Degrees of Lewdity VERSION.html.mod.html" "${HOME}/.DOL/index.html"
