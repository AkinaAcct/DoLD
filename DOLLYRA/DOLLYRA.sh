#!/usr/bin/env bash
# By Akina
# INFO:           SCRIPT FOR DOL-LYRA

DOWNLINKS=($(curl -sL https://api.github.com/repos/DoL-Lyra/Lyra/releases/latest | jq -r .assets\[].browser_download_url | grep zip | sed 's/https:\/\/github.com\/DoL-Lyra\/Lyra\/releases\/download\///g'))
# msg_info "${DOWNLINKS[*]}"
unset LYRAALLVARIANT
for i in "${!DOWNLINKS[@]}"; do
    LYRAALLVARIANT+=(${DOWNLINKS[${i}]})
done
msg_info "Please select one of the versions below (use the numerical sequence):"
N=0
for i in "${LYRAALLVARIANT[@]}"; do
    printf "${BLUE}%s${RESET}\n" "$((N+1)) ${i}"
    N=$((N+1))
done
msg_info "Which one do you want: "
read -r CHOICE
if [[ "$CHOICE" =~ ^[0-9]+$ ]] && ((CHOICE > 0 && CHOICE <= ${#LYRAALLVARIANT[@]})); then
    LYRAVARIANT="${LYRAALLVARIANT[$((CHOICE - 1))]}"
    msg_info "Selected ${CHOICE}: ${LYRAVARIANT}"
else
    msg_fatal "Invalid input. Aborted."
    exit 1
fi
DOWNLINK="https://github.com/DoL-Lyra/Lyra/releases/download/${LYRAVARIANT}"
msg_info "Downloading... Url: ${DOWNLINK}"
if ! (curl --progress-bar -L "${DOWNLINK}" -o ${WORKDIR}/dol.zip); then
    msg_fatal "Download failed. Aborted."
else
    msg_info "Done."
fi
msg_info "Unzipping..."
if ! (unzip ${WORKDIR}/dol.zip -d "${IPREFIX}/DoL-Lyra"); then
    msg_fatal "Unzip failed. Aborted."
else
    msg_info "Done."
fi
msg_info "Finished installation for DoL-Lyra. Path: ${IPREFIX}/DoL-Lyra."
