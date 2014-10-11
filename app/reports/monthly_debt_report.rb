
class MonthlyDebtReport

  def initialize(timestamp=Time.now)
    @timestamp = timestamp
  end

  def income
    @income ||= summarize Category.income.self_and_descendants
  end

  def expenses
    @expenses ||= summarize Category.expense.self_and_descendants
  end

  def net_income
    income.map(&:cents).sum - expenses.map(&:cents).sum
  end

private
  attr_reader :timestamp

  CategorySummary = Struct.new(:category, :cents)

  def debt_account_ids
    @debt_account_ids ||= Account.debt.pluck(:id)
  end
  
  def time_period
    timestamp.at_beginning_of_month.to_date .. timestamp.at_end_of_month.to_date
  end

  def totals_by_category
    @totals_by_category ||= Transaction.where(date: time_period)
                                       .where(account_id: debt_account_ids)
                                       .group(:category_id)
                                       .sum(:cents)
  end

  def summarize(categories)
    categories.map do |cat|
      CategorySummary.new(cat, totals_by_category[cat.id])
    end.reject {|s| s.cents == nil }.sort_by(&:cents).reverse
  end

end