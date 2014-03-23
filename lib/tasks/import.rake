
namespace :import do
  task :all => :environment do
    ImportService.new(logger: Rails.logger).call
  end

  task :review => :environment do
    require 'command_line_handler'
    ReviewService.new(CommandLineHandler.new).call
  end
end