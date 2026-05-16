#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DHCP_DIR="${BASE_DIR}/configs/dhcp"

SRC_CONF="${DHCP_DIR}/dhcpd.conf"
SRC_DEFAULT="${DHCP_DIR}/isc-dhcp-server"

DST_CONF="/etc/dhcp/dhcpd.conf"
DST_DEFAULT="/etc/default/isc-dhcp-server"

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "[ERROR] Ejecuta este script como root"
    exit 1
  fi
}

check_files() {
  [[ -f "${SRC_CONF}" ]] || { echo "[ERROR] Falta ${SRC_CONF}"; exit 1; }
  [[ -f "${SRC_DEFAULT}" ]] || { echo "[ERROR] Falta ${SRC_DEFAULT}"; exit 1; }
}

install_dhcp() {
  apt update
  apt install -y isc-dhcp-server
}

backup_current_config() {
  mkdir -p /root/predeploy-backups/dhcp
  [[ -f "${DST_CONF}" ]] && cp "${DST_CONF}" "/root/predeploy-backups/dhcp/dhcpd.conf.$(date +%F-%H%M%S)"
  [[ -f "${DST_DEFAULT}" ]] && cp "${DST_DEFAULT}" "/root/predeploy-backups/dhcp/isc-dhcp-server.$(date +%F-%H%M%S)"
}

deploy_config() {
  cp "${SRC_CONF}" "${DST_CONF}"
  cp "${SRC_DEFAULT}" "${DST_DEFAULT}"
}

validate_config() {
  dhcpd -t -cf "${DST_CONF}"
}

restart_service() {
  systemctl restart isc-dhcp-server
  systemctl enable isc-dhcp-server
}

show_status() {
  echo "[OK] DHCP desplegado correctamente"
  systemctl --no-pager --full status isc-dhcp-server || true
}

main() {
  require_root
  check_files
  install_dhcp
  backup_current_config
  deploy_config
  validate_config
  restart_service
  show_status
}

main "$@"
