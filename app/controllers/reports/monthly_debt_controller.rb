require 'month_enumerator'
require 'csv'

module Reports
  class MonthlyDebtController < ApplicationController

    def show
      respond_to do |format|
        format.html
        format.csv { render text: to_csv }
      end
    end

  private

    def to_csv
      CSV.generate do |csv|
        csv << %w(month net)
        months.each {|date, net| csv << [date, net] }
      end
    end

    def months
      MonthEnumerator.since_first_transaction.map do |year, month|
        time = Time.local(year, month, 1,  0, 0, 0)
        stamp = (time.utc.to_f * 1000).to_i

        [stamp, MonthlyDebtReport.new(time).net_income / 100.0]
      end
    end

  end
end