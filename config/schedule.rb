job_type :rake, "cd :path && rake :task"

every 1.day, at: "6:00pm" do
  rake "import:recent"
end
