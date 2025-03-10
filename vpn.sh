#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

PID_FILE_PATH='/var/run/vpn.pid'
LOG_PATH='/tmp/openconnect.log'

set -o allexport; source "${HOME}/.openconnect/connection-info.env"; set +o allexport

start() {
  if ! is_network_available; then
    echo "Network is not available. Check your internet connection"
    exit 1
  fi

  if is_vpn_running; then
    echo "VPN is already running"
    exit 1
  fi

  echo "Connecting to ${HOST}"
  echo "${PASSWORD}" | openconnect "${HOST}" --user="${USERNAME}" --authgroup "${AUTHGROUP}" --background --script "vpn-slice --no-ns-hosts --no-host-names --verbose $HOSTS_TO_ROUTE" --passwd-on-stdin --pid-file "$PID_FILE_PATH" > "$LOG_PATH" 2>&1

  if is_vpn_running; then
    echo "VPN is connected"
    print_current_ip_address
  else
    echo "VPN failed to connect!"
  fi
}

stop() {
  if is_vpn_running; then
    rm -f "$PID_FILE_PATH" >/dev/null 2>&1
    kill -9 "$(pgrep openconnect)" >> "$LOG_PATH" 2>&1 || true
  fi

  echo "VPN is disconnected"
  print_current_ip_address
}

status() {
  is_vpn_running && echo "VPN is running" || echo "VPN is stopped"
}

restart () {
  stop
  start
}

print_info() {
  echo "Usage: $(basename "$0") (start|stop|restart|status)"
}

is_network_available() {
  ping -q -c 1 -W 1 8.8.8.8 >/dev/null 2>&1
}

is_vpn_running() {
  test ! -f "$PID_FILE_PATH" && return 1
  local pid
  pid=$(cat "$PID_FILE_PATH")
  kill -0 "$pid" >/dev/null 2>&1
}

print_current_ip_address() {
  local ip
  ip=$(timeout 5 dig +short myip.opendns.com @resolver1.opendns.com)
  [[ -z "$ip" ]] && ip="unknown"
  echo "Your IP address is $ip"
}

case "$1" in
start)
  start
  ;;
stop)
  stop
  ;;
status)
  status
  ;;
restart)
  restart
  ;;
*)
  print_info
  exit 0
  ;;
esac