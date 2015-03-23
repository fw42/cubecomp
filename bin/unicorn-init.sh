#!/bin/sh
# http://www.gotealeaf.com/blog/setting-up-your-production-server-with-nginx-and-unicorn

APP_ROOT="$HOME/app/current"
RAILS_ENV=production
PID=$APP_ROOT/tmp/unicorn.pid
DESC="Cubecomp unicorn webserver ($RAILS_ENV)"

RBENV_ROOT="$HOME/.rbenv"
PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"

SET_PATH="cd $APP_ROOT && rbenv rehash && rbenv local $RBENV_RUBY_VERSION"
UNICORN="bundle exec unicorn"
UNICORN_OPTS="-c $APP_ROOT/config/unicorn.rb -E $RAILS_ENV -D"
CMD="$SET_PATH && $UNICORN $UNICORN_OPTS"

TIMEOUT=30

# Store the action that we should take from the service command's first
# argument (e.g. start, stop, upgrade).
action="$1"

# Make sure the script exits if any variables are unset. This is short for
# set -o nounset.
set -u

# Set the location of the old pid. The old pid is the process that is getting
# replaced.
old_pid="$PID.oldbin"

# Make sure the APP_ROOT is actually a folder that exists. An error message from
# the cd command will be displayed if it fails.
cd $APP_ROOT || exit 1

# A function to send a signal to the current unicorn master process.
sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

# Send a signal to the old process.
oldsig () {
  test -s $old_pid && kill -$1 `cat $old_pid`
}

# A switch for handling the possible actions to take on the unicorn process.
case $action in
  # Start the process by testing if it's there (sig 0), failing if it is,
  # otherwise running the command as specified above.
  start)
    sig 0 && echo >&2 "$DESC is already running" && exit 0
    eval $CMD
    ;;

  # Graceful shutdown. Send QUIT signal to the process. Requests will be
  # completed before the processes are terminated.
  stop)
    sig QUIT && echo "Stopping $DESC" && exit 0
    echo >&2 "Not running"
    ;;

  # Quick shutdown - kills all workers immediately.
  force-stop)
    sig TERM && echo "Force-stopping $DESC" && exit 0
    echo >&2 "Not running"
    ;;

  # Graceful shutdown and then start.
  restart)
    sig QUIT && echo "Restarting $DESC" && sleep 2 && eval $CMD && exit 0
    echo >&2 "Couldn't restart."
    ;;

  # Reloads config file (unicorn.rb) and gracefully restarts all workers. This
  # command won't pick up application code changes if you have `preload_app
  # true` in your unicorn.rb config file.
  reload)
    sig HUP && echo "Reloading configuration for $DESC" && exit 0
    echo >&2 "Couldn't reload configuration."
    ;;

  # Re-execute the running binary, then gracefully shutdown old process. This
  # command allows you to have zero-downtime deployments. The application may
  # spin for a minute, but at least the user doesn't get a 500 error page or
  # the like. Unicorn interprets the USR2 signal as a request to start a new
  # master process and phase out the old worker processes. If the upgrade fails
  # for some reason, a new process is started.
  upgrade)
    if sig USR2 && echo "Upgrading $DESC" && sleep 3 && sig 0 && oldsig QUIT
    then
      n=$TIMEOUT
      while test -s $old_pid && test $n -ge 0
      do
        printf '.' && sleep 1 && n=$(( $n - 1 ))
      done
      echo

      if test $n -lt 0 && test -s $old_pid
      then
        echo >&2 "$old_pid still exists after $TIMEOUT seconds"
        exit 1
      fi
      exit 0
    fi
    echo >&2 "Couldn't upgrade, starting '$CMD' instead"
    eval $CMD
    ;;

  # A basic status checker. Just checks if the master process is responding to
  # the `kill` command.
  status)
    sig 0 && echo >&2 "$DESC is running." && exit 0
    echo >&2 "$DESC is not running."
    ;;

  # Reopen all logs owned by the master and all workers.
  reopen-logs)
    sig USR1
    ;;

  # Any other action gets the usage message.
  *)
    # Usage
    echo >&2 "Usage: $0 <start|stop|restart|reload|upgrade|force-stop|reopen-logs>"
    exit 1
    ;;
esac
