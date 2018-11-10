#!/usr/bin/env bash
set -euo pipefail

apt_prereqs_install() {
  local COMPOSE_VER

  COMPOSE_VER=$(run_sh "$SCRIPTDIR" "env_get" "COMPOSE_VERSION" "$BASEDIR/.env")

  sudo add-apt-repository universe > /dev/null 2>&1 \
    || err "Error adding universe repository."

  sudo apt-get remove docker docker-engine docker.io > /dev/null 2>&1 \
    || err "Error cleaning legacy packages."

  run_sh "$SCRIPTDIR" "apt_install" "apt-transport-https" \
    "ca-certificates" "curl" "software-properties-common"

  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    apt-key add - > /dev/null 2>&1 \
    || err "Error adding Docker GPG key."
  
  sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" \
    > /dev/null 2>&1 \
    || err "Error adding Docker repository."
  
  run_sh "$SCRIPTDIR" "apt_install" "docker-ce"

  sudo curl -fsSL https://github.com/docker/compose/releases/download/"${COMPOSE_VER}"/docker-compose-"$(uname -s)"-"$(uname -m)" \
    -o /usr/local/bin/docker-compose \
    > /dev/null 2>&1 \
    || err "Error installing Docker Compose."
  
  return
}