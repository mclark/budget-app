
namespace :import do
  task :all => :environment do
    ImportService.new(logger: Rails.logger).call
  end
end