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
        months.each {|year, month, net| csv << ["#{year}-#{month}", net] }
      end
    end

    def months
      MonthEnumerator.since_first_transaction.map do |year, month|
        [year, month, MonthlyDebtReport.new(Time.local(year, month, 1, 0, 0, 0)).net_income / 100.0]
      end
    end

  end
end