
class MonthlyBudgetReport

  def initialize(timestamp=Time.now)
    @timestamp = timestamp
  end

  def budgeted
    @budgeted ||= summarize Category.expense.self_and_descendants.budgeted
  end

  def unbudgeted
    @unbudgeted ||= summarize Category.expense.self_and_descendants.unbudgeted
  end

private
  attr_reader :timestamp

  CategorySummary = Struct.new(:category, :cents) do
    def budget_percentage
      if category.budgeted?
        cents.to_f / category.budgeted_cents
      else
        0.0
      end
    end

    def budget_remaining
      if category.budgeted?
        category.budgeted_cents - cents
      else
        0.0
      end
    end
  end

  def time_period
    timestamp.at_beginning_of_month .. timestamp.at_end_of_month
  end

  def totals_by_category
    @totals_by_category ||= Transaction.where(date: time_period).group(:category_id).sum(:cents)
  end

  def summarize(categories)
    categories.map do |cat|
      CategorySummary.new(cat, totals_by_category[cat.id])
    end.reject {|s| s.cents == nil }.sort_by(&:cents).reverse
  end

end