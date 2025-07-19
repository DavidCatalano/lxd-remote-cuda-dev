#!/bin/bash

# PulseAudio control script for macOS

DEVBOX_IP="10.0.0.10"
TIMEOUT=600

show_usage() {
  cat <<EOF
Usage: $0 [start|stop|status|help]

Commands:
  start    Start PulseAudio with network module for Devbox (${DEVBOX_IP})
  stop     Stop PulseAudio
  status   Show PulseAudio and network module status
EOF
}

require_pulseaudio() {
  if ! command -v pulseaudio >/dev/null 2>&1; then
    echo "Error: PulseAudio not found. Please install it (e.g. via Homebrew)." >&2
    exit 1
  fi
}

audio_start() {
  echo "Starting PulseAudio..."
  pkill -x pulseaudio >/dev/null 2>&1 || true
  sleep 1
  pulseaudio \
    --load="module-native-protocol-tcp auth-ip-acl=${DEVBOX_IP} auth-anonymous=1" \
    --exit-idle-time=${TIMEOUT} \
    -D
  echo "PulseAudio started (timeout: ${TIMEOUT}s)."
}

audio_stop() {
  echo "Stopping PulseAudio..."
  if pkill -x pulseaudio; then
    echo "PulseAudio stopped."
  else
    echo "PulseAudio was not running."
  fi
}

audio_status() {
  if pgrep -x pulseaudio > /dev/null; then
    echo "PulseAudio: RUNNING"
    if lsof -nP -c pulseaudio | grep -q ":4713"; then
      echo "Network module: ACTIVE (TCP port 4713)"
    else
      echo "Network module: NOT ACTIVE"
    fi
  else
    echo "PulseAudio: STOPPED"
  fi
}

# Main
require_pulseaudio

case "$1" in
  start)   audio_start   ;;
  stop)    audio_stop    ;;
  status)  audio_status  ;;
  help|--help|-h) show_usage ;;
  *)       show_usage; exit 1 ;;
esac
