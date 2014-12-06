job_type :rake, "cd :path && RAILS_ENV=:rails_env rake :task >> log/cron.log 2>&1"

every 1.day, at: "11:00pm" do
  rake "import:recent"
end
