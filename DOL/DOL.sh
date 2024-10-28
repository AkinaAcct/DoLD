#!/usr/bin/env bash
# By Akina
# INFO:           SCRIPT FOR ORIGINAL DOL

DOWNLINKS="$(curl -sL https://api.github.com/repos/Lyoko-Jeremie/DoLModLoaderBuild/releases/latest | jq -r .assets[].browser_download_url | grep DoL-ModLoader)"
msg_info "Downloading... Url: ${DOWNLINKS}"
if ! (curl --progress-bar -L "${DOWNLINKS}" -o ${WORKDIR}/dol.zip); then
    msg_fatal "Download failed. Aborted."
else
    msg_info "Done."
fi
msg_info "Unzipping..."
mkdir -p "${IPREFIX}/DoL"
if ! (unzip ${WORKDIR}/dol.zip -d "${IPREFIX}/DoL"); then
    msg_fatal "Unzip failed. Aborted."
else
    msg_info "Done."
fi
msg_info "Finished installation for DoL. Path: ${IPREFIX}/DoL."
