class ImportableAccount < ActiveRecord::Base
  belongs_to :account, class_name: "Account", foreign_key: "imported_id"

  has_many :importable_transactions, foreign_key: "account_id", primary_key: "source_id"

  scope :imported, -> { where("imported_id is not null") }
  scope :not_imported, -> { where(imported_id: nil) }

  validates :name, presence: true

  def transactions_count
    importable_transactions.count
  end

  def transactions_value
    importable_transactions.income.sum(:cents) - importable_transactions.expense.sum(:cents)
  end
end
