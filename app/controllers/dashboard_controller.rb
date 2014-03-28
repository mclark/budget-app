
class DashboardController < ApplicationController

  def show
    @income = summarize Category.income.self_and_descendants

    @expenses = summarize Category.expense.self_and_descendants

    @net_income = @income.map(&:last).sum - @expenses.map(&:last).sum
  end

private
  #TODO: refactor all of this into a report object

  def selected_year
    params.fetch(:year, Time.now.year).to_i
  end
  helper_method :selected_year

  def selected_month
    params.fetch(:month, Time.now.month).to_i
  end
  helper_method :selected_month

  def time
    Time.local(selected_year, selected_month, 1, 0, 0, 0)
  end
  helper_method :time

  def selectable_years
    [Time.now.year, Time.now.year - 1]
  end

  def selectable_months(year)
    if year == Time.now.year
      (1..Time.now.month).to_a
    else
      (1..12).to_a
    end
  end

  def selectable_periods
    selectable_years.inject([]) {|arr, y| selectable_months(y).reverse.each {|m| arr << [y,m] }; arr }
  end
  helper_method :selectable_periods

  def totals_by_category
    @totals_by_category ||= Transaction.where(date: time_period).group(:category_id).sum(:cents)
  end

  def time_period
    time.at_beginning_of_month .. time.at_end_of_month
  end

  def summarize(categories)
    categories.map do |cat|
      [cat, totals_by_category[cat.id]]
    end.reject {|c,t| t == nil }.sort_by(&:last).reverse
  end

end