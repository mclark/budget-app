class Account < ActiveRecord::Base
  has_many :mint_accounts, foreign_key: "imported_id"
  
  has_many :transactions

  def transactions_count
    transactions.count
  end
end
