
class DashboardController < ApplicationController

  def show
    period = Time.now.at_beginning_of_month .. Time.now.at_end_of_month

    totals = Transaction.where(date: period).group(:category_id).sum(:cents)

    @income = Category.income.self_and_descendants.map do |cat|
      [cat, totals[cat.id]]
    end.reject {|c,t| t == nil }.sort_by(&:last).reverse

    @expenses = Category.expense.self_and_descendants.map do |cat|
      [cat, totals[cat.id]]
    end.reject {|c,t| t == nil }.sort_by(&:last).reverse

    @net_income = @income.map(&:last).sum - @expenses.map(&:last).sum
  end

end