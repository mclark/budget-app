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
        csv << %w(month net total)
        months.each {|row| csv << row }
      end
    end

    def months
      MonthEnumerator.since_first_transaction.map do |year, month|
        time = Time.local(year, month, 1,  0, 0, 0)
        
        stamp = (time.utc.to_f * 1000).to_i

        net_diff = MonthlyDebtReport.new(time).net_income / 100.0

        [stamp, net_diff]
      end.inject([]) do |rows, nxt|
        nxt << rows.map(&:second).sum + nxt.last

        rows << nxt
      end
    end

  end
end