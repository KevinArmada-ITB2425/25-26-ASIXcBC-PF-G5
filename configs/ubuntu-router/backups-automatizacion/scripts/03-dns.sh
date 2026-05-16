#!/usr/bin/env bash
set -euo pipefail

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "[ERROR] Ejecuta este script como root"
    exit 1
  fi
}

install_technitium() {
  curl -sSL https://download.technitium.com/dns/install.sh | bash
}

show_next_steps() {
  echo "[OK] Technitium instalado"
  echo "[INFO] Abre: http://<IP_DEL_SERVIDOR>:5380/"
  echo "[INFO] Configura la contraseña de admin y tus zonas DNS desde la web"
}

main() {
  require_root
  install_technitium
  show_next_steps
}

main "$@"
