
namespace :import do
  task :all => :environment do
    # begin  
      ImportService.new(logger: Rails.logger).call
    # rescue ImportService::ImportError => e
    #   $stderr.puts "#{e.cause.class} raised in import"
    #   raise e
    # end
  end
end
