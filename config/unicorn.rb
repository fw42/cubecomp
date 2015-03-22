# Set the current app's path for later reference. Rails.root isn't available at
# this point, so we have to point up a directory.
app_path = File.expand_path(File.dirname(__FILE__) + '/..')

# The number of worker processes you have here should equal the number of CPU
# cores your server has.
worker_processes (ENV['RAILS_ENV'] == 'production' ? 4 : 1)

# Listen on port 50000
listen("127.0.0.1:50000", backlog: 64)

# After the timeout is exhausted, the unicorn worker will be killed and a new
# one brought up in its place. Adjust this to your application's needs. The
# default timeout is 60. Anything under 3 seconds won't work properly.
timeout 30

# Set the working directory of this unicorn instance.
working_directory app_path

# Set the location of the unicorn pid file. This should match what we put in the
# unicorn init script later.
pid app_path + '/tmp/unicorn.pid'

# You should define your stderr and stdout here. If you don't, stderr defaults
# to /dev/null and you'll lose any error logging when in daemon mode.
stderr_path app_path + '/log/unicorn.log'
stdout_path app_path + '/log/unicorn.log'

# Load the app up before forking.
preload_app true

# Garbage collection settings.
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

# If using ActiveRecord, disconnect (from the database) before forking.
before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

# After forking, restore your ActiveRecord connection.
after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
