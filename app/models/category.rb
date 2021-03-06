
class Category < ActiveRecord::Base
  acts_as_nested_set
  has_many :transactions

  ALLOWED_ROOTS = %w(Income Expense Transfers).freeze

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

  def self.invalidate_cache!
    @income = nil
    @expense = nil
    @transfers = nil
    @transfer_from = nil
    @transfer_to = nil
  end

  scope :budgeted, -> { where("budgeted_cents > 0") }
  scope :unbudgeted, -> { where("budgeted_cents is null or budgeted_cents <= 0") }

  validates_inclusion_of :name, in: ALLOWED_ROOTS, if: :root?

  after_create { Category.invalidate_cache! }

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

  def budgeted?
    (budgeted_cents || 0) > 0
  end

  def income?
    root == Category.income
  end

  def expense?
    root == Category.expense
  end

  def transfer?
    root == Category.transfers
  end
end
