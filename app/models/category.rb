
class Category < ActiveRecord::Base
  acts_as_nested_set
  has_many :transactions

  ALLOWED_ROOTS = %w(Income Expense Transfers).freeze

  # TODO: fixturize this data
  def self.income
    @income ||= roots.where(name: "Income").first
  end

  def self.expense
    @expense ||= roots.where(name: "Expense").first
  end

  def self.transfers
    @transfers ||= roots.where(name: "Transfers").first
  end

  def self.transfer_from
    @transfer_from ||= where(parent_id: transfers, name: "Transfer From").first
  end

  def self.transfer_to
    @transfer_to ||= where(parent_id: transfers, name: "Transfer To").first
  end

  validates_inclusion_of :name, in: ALLOWED_ROOTS, if: :root?

  def can_edit?
    can_destroy?
  end

  def can_destroy?
    !root? && self.parent != Category.transfers
  end

  def transactions_count
    # TODO: should include child category transactions count?
    transactions.count
  end
end
