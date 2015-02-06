require 'mint'
require 'logger'

namespace :import do
  def import!
    ImportService.new(logger: Logger.new($stdout)).call

    if [MintAccount, MintTransaction].any? {|model| model.not_imported.any? }
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
    max = [Transaction.maximum(:date), MintTransaction.maximum(:date)].max
    
    Mint.since_date = max.to_time - 1.week
    
    Rake::Task["import:all"].invoke
  end

  task :since => :environment do
    Mint.since_date = Chronic.parse(ENV.fetch("SINCE"))

    print "Did you mean #{Mint.since_date.strftime("%b %d %Y")}? <Y/N>"

    exit unless $stdin.readline.strip.downcase == "y"

    Rake::Task["import:all"].invoke
  end
end
