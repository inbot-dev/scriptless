#!/bin/bash
# herza-init.sh — Ubuntu 24.04 bootstrap
# Virtualmin full LAMP, optional GitHub CLI auth, Squid auth proxy, Node 24, Docker, etc.
#
# Usage:
#   export GITHUB_TOKEN='ghp_...'   # optional; also accepts GH_TOKEN
#   export PROXY_USER='proxyuser'   # optional
#   export PROXY_PASS='...'         # optional; random if unset
#   export PROXY_PORT='3128'        # optional
#   export PROXY_IP_ALLOWED='*'     # optional; * = all (auth required)
#   sudo -E ./herza-init.sh

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# --- Configurable (env overrides) ---
PROXY_USER="${PROXY_USER:-proxyuser}"
PROXY_PASS="${PROXY_PASS:-}"
PROXY_PORT="${PROXY_PORT:-3128}"
PROXY_IP_ALLOWED="${PROXY_IP_ALLOWED:-*}"
GITHUB_TOKEN="${GITHUB_TOKEN:-${GH_TOKEN:-}}"

SQUID_DIR="/etc/squid"
SQUID_CONF="${SQUID_DIR}/squid.conf"
SQUID_PASSWD="${SQUID_DIR}/passwd"
SQUID_CRED="${SQUID_DIR}/squidcred.txt"

log() { echo "[herza-init] $*"; }
warn() { echo "[herza-init] WARNING: $*" >&2; }
die() { echo "[herza-init] ERROR: $*" >&2; exit 1; }

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    die "Run as root (or: sudo -E $0)"
  fi
}

generate_password() {
  openssl rand -hex 8
}

is_reserved_port() {
  local port="$1"
  local reserved=(20 21 22 25 53 80 110 143 443 465 587 993 995 2222 20000)
  local p
  for p in "${reserved[@]}"; do
    [[ "$port" == "$p" ]] && return 0
  done
  if [[ "$port" -ge 10000 && "$port" -le 10100 ]]; then
    return 0
  fi
  return 1
}

open_firewall_port() {
  local port="$1"
  if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld 2>/dev/null; then
    log "Opening ${port}/tcp via firewalld"
    firewall-cmd --permanent --add-port="${port}/tcp" || true
    firewall-cmd --reload || true
  elif command -v ufw >/dev/null 2>&1 && ufw status 2>/dev/null | grep -qi 'Status: active'; then
    log "Opening ${port}/tcp via UFW"
    ufw allow "${port}/tcp" || true
  else
    warn "No active firewalld/UFW found; open TCP ${port} manually if needed"
  fi
}

find_basic_ncsa_auth() {
  local candidates=(
    /usr/lib/squid/basic_ncsa_auth
    /usr/libexec/squid/basic_ncsa_auth
    /usr/lib/squid3/basic_ncsa_auth
  )
  local c
  for c in "${candidates[@]}"; do
    if [[ -x "$c" ]]; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

# --- 1) Base packages (no Squid config yet) ---
install_base_packages() {
  log "Updating apt and installing base packages"
  apt-get update -y
  apt-get clean -y || true
  apt-get install -y \
    wget curl unzip zip nano rar screen git fontconfig dos2unix \
    ufw iptables fail2ban \
    software-properties-common apt-transport-https ca-certificates gnupg lsb-release \
    build-essential
  apt-get upgrade -y
}

# --- 2) Virtualmin full LAMP ---
install_virtualmin() {
  log "Installing Virtualmin GPL full LAMP"
  sh -c "$(curl -fsSL https://download.virtualmin.com/virtualmin-install)" -- --bundle LAMP -y
}

# --- 3) Conditional PHP (skip if Virtualmin already provides PHP) ---
install_php_fallback() {
  if command -v php >/dev/null 2>&1 || dpkg -l 'php*' 2>/dev/null | grep -q '^ii'; then
    log "PHP already present (Virtualmin); skipping Ondrej PHP 8.2"
    return 0
  fi
  log "PHP not found; installing PHP 8.2 via Ondrej PPA"
  add-apt-repository -y ppa:ondrej/php
  apt-get update -y
  apt-get install -y \
    php8.2 php8.2-common php8.2-mysql php8.2-xml php8.2-xmlrpc php8.2-curl \
    php8.2-gd php8.2-imagick php8.2-cli php8.2-dev php8.2-imap php8.2-mbstring \
    php8.2-opcache php8.2-soap php8.2-zip php8.2-intl
}

# --- 4) GitHub CLI auth (env token) ---
install_and_auth_github() {
  log "Installing GitHub CLI (gh)"
  if ! command -v gh >/dev/null 2>&1; then
    mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list
    apt-get update -y
    apt-get install -y gh
  fi

  if [[ -z "${GITHUB_TOKEN}" ]]; then
    warn "GITHUB_TOKEN / GH_TOKEN not set; skipping gh auth login"
    return 0
  fi

  log "Authenticating GitHub CLI with token (token not logged)"
  if ! printf '%s\n' "${GITHUB_TOKEN}" | gh auth login --with-token; then
    warn "gh auth login failed; continuing without GitHub auth"
    return 0
  fi
  gh auth setup-git || warn "gh auth setup-git failed"
  gh auth status || true

  if [[ -n "${GITHUB_USER:-}" ]]; then
    git config --global user.name "${GITHUB_USER}"
  fi
  if [[ -n "${GIT_AUTHOR_NAME:-}" ]]; then
    git config --global user.name "${GIT_AUTHOR_NAME}"
  fi
  if [[ -n "${GIT_AUTHOR_EMAIL:-}" ]]; then
    git config --global user.email "${GIT_AUTHOR_EMAIL}"
  fi
}

# --- 5) Squid auth proxy (after Virtualmin; no port conflicts) ---
configure_squid() {
  if is_reserved_port "${PROXY_PORT}"; then
    die "PROXY_PORT=${PROXY_PORT} conflicts with Virtualmin/system reserved ports. Choose another port (default 3128)."
  fi

  log "Installing Squid + apache2-utils"
  apt-get update -y
  apt-get install -y squid apache2-utils

  local auth_helper
  if ! auth_helper="$(find_basic_ncsa_auth)"; then
    die "basic_ncsa_auth helper not found after installing squid"
  fi

  if [[ -z "${PROXY_PASS}" ]]; then
    PROXY_PASS="$(generate_password)"
    log "Generated random PROXY_PASS"
  fi

  mkdir -p "${SQUID_DIR}"
  if [[ -f "${SQUID_CONF}" ]]; then
    cp -a "${SQUID_CONF}" "${SQUID_CONF}.bak.$(date +%Y%m%d%H%M%S)"
  fi

  htpasswd -cb "${SQUID_PASSWD}" "${PROXY_USER}" "${PROXY_PASS}"
  chown root:proxy "${SQUID_PASSWD}" 2>/dev/null || chown root:root "${SQUID_PASSWD}"
  chmod 640 "${SQUID_PASSWD}"

  local ip_acl_block=""
  local http_access_line="http_access allow authenticated"
  local normalized_ips
  normalized_ips="$(echo "${PROXY_IP_ALLOWED}" | tr ',' ' ' | xargs)"

  if [[ -n "${normalized_ips}" && "${normalized_ips}" != "*" ]]; then
    ip_acl_block="acl allowed_ips src ${normalized_ips}"
    http_access_line="http_access allow allowed_ips authenticated"
  fi

  # Minimal clean conf (no placeholder cache_dir comments that confuse Webmin Squid module)
  cat > "${SQUID_CONF}" <<EOF
# Generated by herza-init.sh — auth forward proxy (do not manage via Webmin Squid UI without re-running this)
http_port ${PROXY_PORT}

auth_param basic program ${auth_helper} ${SQUID_PASSWD}
auth_param basic realm Herza Proxy
auth_param basic credentialsttl 2 hours
acl authenticated proxy_auth REQUIRED

${ip_acl_block}
${http_access_line}
http_access deny all

cache deny all
access_log daemon:/var/log/squid/access.log squid
cache_log /var/log/squid/cache.log
coredump_dir /var/spool/squid
EOF

  umask 077
  cat > "${SQUID_CRED}" <<EOF
user=${PROXY_USER}
password=${PROXY_PASS}
port=${PROXY_PORT}
ipallowed=${PROXY_IP_ALLOWED}
EOF
  chmod 600 "${SQUID_CRED}"
  chown root:root "${SQUID_CRED}"

  log "Validating Squid config"
  if ! squid -k parse -f "${SQUID_CONF}"; then
    warn "Squid config parse failed; Virtualmin left intact. Fix ${SQUID_CONF} manually."
    return 0
  fi

  open_firewall_port "${PROXY_PORT}"
  systemctl enable squid
  systemctl restart squid
  log "Squid ready on port ${PROXY_PORT}; credentials in ${SQUID_CRED}"
}

# --- 6) rclone, Node 24 + PM2, Python, gdown, Docker ---
install_rclone() {
  log "Installing rclone"
  curl -fsSL https://rclone.org/install.sh | bash
}

install_node_pm2() {
  log "Installing Node.js 24 LTS + PM2"
  curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
  apt-get install -y nodejs
  npm install pm2@latest -g
  pm2 install pm2-logrotate || true
  pm2 set pm2-logrotate:max_size 20M || true
  pm2 set pm2-logrotate:dateFormat DD-MM-YYYY_HH-mm-ss || true
  pm2 set pm2-logrotate:TZ Asia/Jakarta || true
  # Non-interactive startup: generate systemd unit if possible
  env PATH="$PATH" pm2 startup systemd -u root --hp /root || true
  pm2 save --force || true
  mkdir -p /root/tools
  # notifRec.js / notif.js intentionally skipped
}

install_python_gdown() {
  log "Installing Python 3.13 + gdown"
  add-apt-repository -y ppa:deadsnakes/ppa
  apt-get update -y
  apt-get install -y python3.13 python3-pip python-is-python3
  pip install --break-system-packages gdown
}

install_docker() {
  log "Installing Docker CE"
  apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -y
  apt-get install -y docker-ce
  systemctl enable --now docker || true
}

configure_time() {
  log "Setting timezone UTC and enabling NTP"
  timedatectl set-timezone UTC
  timedatectl set-ntp true || true
}

main() {
  require_root

  install_base_packages
  install_virtualmin
  install_php_fallback
  install_and_auth_github
  configure_squid
  install_rclone
  install_node_pm2
  install_python_gdown
  install_docker
  configure_time

  apt-get autoremove -y || true
  apt-get clean -y || true

  log "Done."
  log "Virtualmin: https://$(hostname -f 2>/dev/null || hostname):10000"
  log "Squid creds: ${SQUID_CRED}"
  exit 0
}

main "$@"
