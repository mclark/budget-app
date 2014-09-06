require 'mint'

namespace :import do
  task :all => :environment do
    begin  
      ImportService.new(logger: Rails.logger).call
    rescue ImportService::ImportError => e
      $stderr.puts "#{e.cause.class} raised in import"
      raise e
    end
  end

  task :recent => :environment do
    Mint.since_date = Transaction.maximum(:date).to_time - 1.week
    Rake::Task["import:all"].invoke
  end
end
