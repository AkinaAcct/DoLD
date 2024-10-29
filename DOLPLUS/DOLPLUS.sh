#!/usr/bin/env bash
# By Akina
# INFO:           SCRIPT FOR DOL PLUS

# NOTE: DOLP V0.597    example link ↓
# https://gitgud.io/api/v4/projects/28315/packages/generic/DoLP_Modloader/v0.597/DoLP_Modloader_v0.597.zip

msg_info "Now fetching latest release info for DoL-Plus..."
RELEASEFILES="$(curl -sL "https://gitgud.io/api/v4/projects/Frostberg%2Fdegrees-of-lewdity-plus/releases/permalink/latest" | jq -r '.assets.links[].direct_asset_url')"
RELEASEFILES="$(echo "${RELEASEFILES}" | sed 's/https\:\/\/gitgud\.io\/api\/v4\/projects\/28315\/packages\/generic\///g')"
unset PLUSALLVARIANT
for i in "${!RELEASEFILES[@]}"; do
    PLUSALLVARIANT+=(${RELEASEFILES[${i}]})
done
msg_info "Please select one of the versions below (use the numerical sequence):"
N=0
for i in "${PLUSALLVARIANT[@]}"; do
    printf "${BLUE}%s${RESET}\n" "$((N + 1)) ${i}"
    N=$((N + 1))
done
msg_info "Which one do you want: "
read -r CHOICE
if [[ "$CHOICE" =~ ^[0-9]+$ ]] && ((CHOICE > 0 && CHOICE <= ${#PLUSALLVARIANT[@]})); then
    PLUSVARIANT="${PLUSALLVARIANT[$((CHOICE - 1))]}"
    msg_info "Selected ${CHOICE}: ${PLUSVARIANT}"
else
    msg_fatal "Invalid input. Aborted."
    exit 1
fi
msg_info "Now downloading..."
if ! (curl --progress-bar -L "https://gitgud.io/api/v4/projects/28315/packages/generic/${PLUSVARIANT}" -o "${WORKDIR}/dol.zip"); then
    msg_fatal "Download failed. Check your network and retry."
else
    msg_info "Done."
fi
msg_info "Now unzipping..."
if ! (unzip ${WORKDIR}/dol.zip -d ${IPREFIX}/DoL-Plus); then
    msg_fatal "Unzip failed."
else
    msg_info "Done."
fi
msg_info "Finished installation for DoL-Plus. Path: ${IPREFIX}/DoL-Plus."
