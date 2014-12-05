rails_env = ENV["RAILS_ENV"] || "development"

app_root = File.expand_path("..", __dir__)

preload_app true

worker_processes ENV.fetch("UNICORN_WORKERS", "2").to_i

working_directory app_root

if rails_env == "development"
  listen 3000, :tcp_nopush => true
else
  listen File.join(app_root, "tmp", "sockets", "unicorn.sock"), :backlog => 64

  pid_path = File.join(app_root, "tmp", "pids", "unicorn.pid")
  pid pid_path

  stderr_path File.join(app_root, "log", "unicorn.log")
  stdout_path File.join(app_root, "log", "unicorn.log")
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
  old_pid_path = "#{pid_path}.oldbin"
  if File.exists?(old_pid_path) && server.pid != old_pid_path
    begin
      Process.kill("QUIT", File.read(old_pid_path).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
