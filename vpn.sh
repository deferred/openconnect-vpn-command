#!/bin/bash

PID_FILE_PATH='/var/run/vpn.pid'
LOG_PATH='/tmp/openconnect.log'

set -o allexport; source "${HOME}/.openconnect/connection-info.env"; set +o allexport

function start() {

  if ! is_network_available; then
    printf "Network is not available. Check your internet connection \n"
    exit 1
  fi

  if is_vpn_running; then
    printf "VPN is already running\n"
    exit 1
  fi

  echo "Connecting to ${HOST}"
  echo "${PASSWORD}" | openconnect "${HOST}" --user="${USERNAME}" --authgroup "${AUTHGROUP}" --background --passwd-on-stdin --pid-file $PID_FILE_PATH >$LOG_PATH 2>&1

  if is_vpn_running; then
    printf "VPN is connected \n"
    print_current_ip_address
  else
    printf "VPN failed to connect! \n"
  fi
}

function status() {
  is_vpn_running && printf "VPN is running \n" || printf "VPN is stopped \n"
}

function stop() {

  if is_vpn_running; then
    rm -f $PID_FILE_PATH >/dev/null 2>&1
    kill -9 "$(pgrep openconnect)" >/dev/null 2>&1
  fi

  printf "VPN is disconnected \n"
  print_current_ip_address
}

function print_info() {
  echo "Usage: $(basename "$0") (start|stop|status|restart)"
}

function is_network_available() {
  ping -q -c 1 -W 1 8.8.8.8 >/dev/null 2>&1
}

function is_vpn_running() {
  test ! -f $PID_FILE_PATH && return 1
  local pid
  pid=$(cat $PID_FILE_PATH)
  kill -0 "$pid" >/dev/null 2>&1
}

function print_current_ip_address() {
  local ip
  ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  printf "Your IP address is %s \n" "$ip"
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

  $0 stop
  $0 start
  ;;

*)

  print_info
  exit 0
  ;;
esac
