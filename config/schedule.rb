job_type :rake, "cd :path && RAILS_ENV=:rails_env bundle exec rake :task >> log/cron.log 2>&1"
job_type :xvfb_rake, "cd :path && XVFB=true RAILS_ENV=:rails_env bundle exec rake :task >> log/cron.log 2>&1"

every 1.day, at: ["7:00am", "7:00pm"] do
  xvfb_rake "import:recent"
end
