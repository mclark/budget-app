
class Category < ActiveRecord::Base
  acts_as_tree
  has_many :transactions

  def transactions_count
    # TODO: should include child category transactions count?
    transactions.count
  end
end
