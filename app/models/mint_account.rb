class MintAccount < ActiveRecord::Base
  belongs_to :account, class_name: "Account", foreign_key: "imported_id"

  has_many :mint_transactions, foreign_key: "account_id", primary_key: "mint_id"

  scope :imported, -> { where("imported_id is not null") }
  scope :not_imported, -> { where(imported_id: nil) }

  validates :name, presence: true

  def transactions_count
    mint_transactions.count
  end

  def transactions_value
    mint_transactions.income.sum(:cents) - mint_transactions.expense.sum(:cents)
  end
end
