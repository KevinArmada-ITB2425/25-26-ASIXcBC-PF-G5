#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/configs/netplan"
NETPLAN_FILE="01-router.yaml"
SRC_FILE="${CONFIG_DIR}/${NETPLAN_FILE}"
DST_FILE="/etc/netplan/${NETPLAN_FILE}"

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "[ERROR] Ejecuta este script como root"
    exit 1
  fi
}

check_source_file() {
  if [[ ! -f "${SRC_FILE}" ]]; then
    echo "[ERROR] No existe el archivo: ${SRC_FILE}"
    exit 1
  fi
}

install_base_packages() {
  apt update
  apt install -y netplan.io iproute2 curl wget vim
}

enable_ip_forward() {
  cat > /etc/sysctl.d/99-router.conf <<'EOF'
net.ipv4.ip_forward=1
EOF
  sysctl --system
}

backup_netplan() {
  mkdir -p /root/predeploy-backups
  if [[ -d /etc/netplan ]]; then
    cp -r /etc/netplan "/root/predeploy-backups/netplan-$(date +%F-%H%M%S)"
  fi
}

deploy_netplan() {
  cp "${SRC_FILE}" "${DST_FILE}"
  chmod 600 "${DST_FILE}"
  netplan generate
  netplan apply
}

show_status() {
  echo "[OK] Configuración base aplicada"
  echo "[INFO] Interfaces actuales:"
  ip -br a
  echo "[INFO] Rutas actuales:"
  ip route
  echo "[INFO] IP forwarding:"
  sysctl net.ipv4.ip_forward
}

main() {
  require_root
  check_source_file
  install_base_packages
  backup_netplan
  enable_ip_forward
  deploy_netplan
  show_status
}

main "$@"
