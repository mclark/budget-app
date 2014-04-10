job_type :rake, "cd :path && rake :task"

every 1.day, at: "8:00pm" do
  rake "import:all"
end
