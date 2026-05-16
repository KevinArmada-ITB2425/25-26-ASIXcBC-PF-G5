#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SURI_DIR="${BASE_DIR}/configs/suricata"

SRC_YAML="${SURI_DIR}/suricata.yaml"
SRC_THRESHOLD="${SURI_DIR}/threshold.config"

DST_YAML="/etc/suricata/suricata.yaml"
DST_THRESHOLD="/etc/suricata/threshold.config"

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "[ERROR] Ejecuta este script como root"
    exit 1
  fi
}

check_files() {
  [[ -f "${SRC_YAML}" ]] || { echo "[ERROR] Falta ${SRC_YAML}"; exit 1; }
  [[ -f "${SRC_THRESHOLD}" ]] || { echo "[ERROR] Falta ${SRC_THRESHOLD}"; exit 1; }
}

install_suricata() {
  apt update
  apt install -y software-properties-common curl
  add-apt-repository -y ppa:oisf/suricata-stable
  apt update
  apt install -y suricata suricata-update jq
}

backup_current_config() {
  mkdir -p /root/predeploy-backups/suricata
  [[ -d /etc/suricata ]] && cp -r /etc/suricata "/root/predeploy-backups/suricata/suricata-$(date +%F-%H%M%S)"
}

deploy_config() {
  cp "${SRC_YAML}" "${DST_YAML}"
  cp "${SRC_THRESHOLD}" "${DST_THRESHOLD}"
  chmod 640 "${DST_YAML}" "${DST_THRESHOLD}"
}

update_rules() {
  suricata-update
}

validate_config() {
  suricata -T -c "${DST_YAML}" -v
}

enable_service() {
  systemctl enable suricata
  systemctl restart suricata
}

show_status() {
  echo "[OK] Suricata desplegado correctamente"
  systemctl --no-pager --full status suricata || true
  echo
  echo "[INFO] Últimas alertas legibles:"
  tail -n 20 /var/log/suricata/fast.log || true
  echo
  echo "[INFO] Últimos eventos JSON:"
  tail -n 20 /var/log/suricata/eve.json || true
}

main() {
  require_root
  check_files
  install_suricata
  backup_current_config
  deploy_config
  update_rules
  validate_config
  enable_service
  show_status
}

main "$@"
