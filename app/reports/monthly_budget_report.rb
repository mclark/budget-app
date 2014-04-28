
class MonthlyBudgetReport

  def initialize(timestamp=Time.now)
    @timestamp = timestamp
  end

  def budgeted
    @budgeted ||= summarize(Category.expense.self_and_descendants.budgeted).sort_by(&:budget_total).reverse
  end

  def total_budget
    budgeted.map(&:budget_total).sum
  end

  def total_spending_remaining
    total_budget - budgeted.map(&:cents).sum.abs
  end

  def unbudgeted
    @unbudgeted ||= summarize(Category.expense.self_and_descendants.unbudgeted).reject {|s| s.cents <= 0 }.sort_by(&:cents).reverse
  end

  def total_unbudgeted_spending
    unbudgeted.map(&:cents).sum.abs
  end

  def total_budgeted_spending
    budgeted.map(&:cents).sum.abs
  end

private
  attr_reader :timestamp

  CategorySummary = Struct.new(:category, :cents) do
    def budget_percentage
      if category.budgeted?
        cents.to_f / budget_total
      else
        0.0
      end
    end

    def budget_total
      category.budgeted_cents
    end

    def budget_remaining
      if category.budgeted?
        budget_total - cents
      else
        0.0
      end
    end
  end

  def time_period
    timestamp.at_beginning_of_month.to_date .. timestamp.at_end_of_month.to_date
  end

  def totals_by_category
    @totals_by_category ||= Transaction.where(date: time_period).group(:category_id).sum(:cents)
  end

  def summarize(categories)
    categories.map do |cat|
      CategorySummary.new(cat, totals_by_category[cat.id] || 0)
    end
  end

end