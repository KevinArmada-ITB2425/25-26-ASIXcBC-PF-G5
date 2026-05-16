#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NFT_DIR="${BASE_DIR}/configs/nftables"

SRC_CONF="${NFT_DIR}/nftables.conf"
DST_CONF="/etc/nftables.conf"

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "[ERROR] Ejecuta este script como root"
    exit 1
  fi
}

check_file() {
  [[ -f "${SRC_CONF}" ]] || { echo "[ERROR] Falta ${SRC_CONF}"; exit 1; }
}

install_nftables() {
  apt update
  apt install -y nftables
}

backup_current_config() {
  mkdir -p /root/predeploy-backups/nftables
  [[ -f "${DST_CONF}" ]] && cp "${DST_CONF}" "/root/predeploy-backups/nftables/nftables.conf.$(date +%F-%H%M%S)"
}

deploy_config() {
  cp "${SRC_CONF}" "${DST_CONF}"
  chmod 600 "${DST_CONF}"
}

validate_config() {
  nft -c -f "${DST_CONF}"
}

apply_config() {
  nft -f "${DST_CONF}"
}

enable_service() {
  systemctl enable nftables
  systemctl restart nftables
}

show_status() {
  echo "[OK] nftables desplegado correctamente"
  systemctl --no-pager --full status nftables || true
  echo
  echo "[INFO] Ruleset cargado:"
  nft list ruleset
}

main() {
  require_root
  check_file
  install_nftables
  backup_current_config
  deploy_config
  validate_config
  apply_config
  enable_service
  show_status
}

main "$@"
