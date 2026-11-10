#!/bin/sh
# Starts/stops the Cubecomp puma webserver in production.
#
#   RBENV_RUBY_VERSION=3.4.12 scripts/puma-init.sh <start|stop|restart|status>
#
# Settings (workers, bind address, pid file, log) are in config/puma.rb.
# Exits non-zero if the requested action failed.

set -u

DIR="$(dirname "$0")"
APP_ROOT="$DIR/.."
RAILS_ENV=production
DESC="Cubecomp puma webserver ($RAILS_ENV)"
PID=tmp/puma.pid
# Must match the bind address in config/puma.rb; used to check that the
# server is up after starting it
HOST=127.0.0.1
PORT=50000
# Seconds to wait for the server to stop or to start
TIMEOUT=60

# Left over from before the switch to puma; stopped on start/restart so
# that it releases the port
UNICORN_PID=tmp/unicorn.pid

RBENV_ROOT="$HOME/.rbenv"
PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
export RAILS_ENV PATH

cd "$APP_ROOT" || exit 1

# Is the process in pid file $1 alive?
running () {
  test -s "$1" && kill -0 "$(cat "$1")" 2>/dev/null
}

# Send signal $2 to the process in pid file $1 and wait for it to exit
stop_process () {
  running "$1" || return 0
  kill -"$2" "$(cat "$1")"
  n=$TIMEOUT
  while running "$1" && [ $n -gt 0 ]; do
    sleep 1
    n=$((n - 1))
  done
  ! running "$1"
}

stop_unicorn () {
  if running "$UNICORN_PID"; then
    echo "Stopping legacy unicorn"
    # QUIT: graceful shutdown for unicorn
    stop_process "$UNICORN_PID" QUIT || { echo >&2 "unicorn did not stop"; return 1; }
  fi
}

stop () {
  stop_unicorn || return 1

  if running "$PID"; then
    echo "Stopping $DESC"
    # TERM: graceful shutdown, finishes in-flight requests
    stop_process "$PID" TERM || { echo >&2 "$DESC did not stop within ${TIMEOUT}s"; return 1; }
  fi
}

start () {
  if running "$PID"; then
    echo "$DESC is already running"
    return 0
  fi

  echo "Starting $DESC"
  rbenv local "${RBENV_RUBY_VERSION:?RBENV_RUBY_VERSION must be set}" || return 1
  rm -f "$PID"

  # puma doesn't daemonize itself: detach it from this shell / SSH session
  setsid nohup bundle exec puma -C config/puma.rb >> log/puma.log 2>&1 < /dev/null &

  # Wait until the puma master is alive and the port accepts connections
  n=$TIMEOUT
  while [ $n -gt 0 ]; do
    if running "$PID" &&
       ruby -rsocket -e "TCPSocket.new('$HOST', $PORT).close" 2>/dev/null; then
      echo "$DESC is up on $HOST:$PORT"
      return 0
    fi
    sleep 1
    n=$((n - 1))
  done

  echo >&2 "$DESC did not come up within ${TIMEOUT}s, see log/puma.log"
  return 1
}

case "${1:-}" in
  start)
    stop_unicorn && start
    ;;
  stop)
    stop
    ;;
  restart)
    stop && start
    ;;
  status)
    if running "$PID"; then
      echo "$DESC is running (pid $(cat "$PID"))"
    else
      echo "$DESC is not running"
      exit 1
    fi
    ;;
  *)
    echo >&2 "Usage: $0 <start|stop|restart|status>"
    exit 1
    ;;
esac
