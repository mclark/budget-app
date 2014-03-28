
class TransferizePolicy

  def initialize(from, to)
    @from = from
    @to = to
  end

  def validate
    catch(:invalid) do
      from_is_expense &&
      to_is_income &&
      amount_is_equal &&
      account_is_different
    end
  end

private
  attr_reader :from, :to

  def from_is_expense
    from.class == Expense or throw :invalid, :from_isnt_expense
  end

  def to_is_income
    to.class == Income or throw :invalid, :to_isnt_income
  end

  def amount_is_equal
    from.cents == to.cents or throw :invalid, :amount_isnt_equal
  end

  def account_is_different
    from.account_id != to.account_id or throw :invalid, :account_isnt_different
  end

end
