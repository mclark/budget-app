class Account < ActiveRecord::Base
  has_many :mint_accounts, foreign_key: "imported_id"
  
  has_many :transactions

  scope :debt, -> { where(debt: true) }

  def transactions_count
    transactions.count
  end
end
