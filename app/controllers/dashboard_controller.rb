
class DashboardController < ApplicationController

  def show
    period = Time.now.at_beginning_of_month .. Time.now.at_end_of_month

    totals = Transaction.where(date: period).group(:category_id).sum(:cents)

    @spending = Category.where(id: totals.keys).map do |c|
      [c, totals[c.id] || 0]
    end.sort_by(&:last).reverse
  end

end