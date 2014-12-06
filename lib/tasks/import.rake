require 'mint'

namespace :import do
  def import!
    begin  
      ImportService.new(logger: Rails.logger).call
    rescue ImportService::ImportError => e
      $stderr.puts "#{e.cause.class} raised in import"
      raise e
    end
  end

  task :all => :environment do
    if ENV['XVFB'].present?
      Headless.ly(display: "99") { import! }
    else
      import!
    end
  end

  task :recent => :environment do
    Mint.since_date = Transaction.maximum(:date).to_time - 1.week
    Rake::Task["import:all"].invoke
  end
end
