require 'mint'
require 'logger'

namespace :import do
  def import!
    ImportService.new(logger: Logger.new($stdout)).call

    if [ImportableAccount, ImportableTransaction].any? {|model| model.not_imported.any? }
      ApplicationMailer.review_reminder.deliver
    end
  end

  task :all => :environment do
    Mint.force_refresh = true

    if ENV['XVFB'].present?
      Headless.ly(display: "99") { import! }
    else
      import!
    end
  end

  task :recent => :environment do
    max = [Transaction.maximum(:date), ImportableTransaction.maximum(:date)].max

    Mint.since_date = max.to_time - 1.week

    Rake::Task["import:all"].invoke
  end

  task :since => :environment do
    Mint.since_date = Chronic.parse(ENV.fetch("SINCE"))

    print "Did you mean #{Mint.since_date.strftime("%b %d %Y")}? <Y/N>"

    exit unless $stdin.readline.strip.downcase == "y"

    Rake::Task["import:all"].invoke
  end

  #temporary task to just bootstrap us for now
  # TODO write a configuration mechanism to import all the things
  task :pcfinancial => :environment do
    PcFinancialImportService.new.call(since: Date.new(2015, 1, 1))
  end
end
