
class Category < ActiveRecord::Base
  acts_as_nested_set
  has_many :transactions

  def transactions_count
    # TODO: should include child category transactions count?
    transactions.count
  end
end
