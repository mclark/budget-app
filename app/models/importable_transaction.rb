class ImportableTransaction < ActiveRecord::Base
  belongs_to :importable_account, class_name: "ImportableAccount", foreign_key: "account_id", primary_key: "source_id"

  scope :imported, -> { where("imported_id is not null") }
  scope :not_imported, -> { where(imported_id: nil) }

  scope :expense, -> { where(expense: true) }
  scope :income, -> { where(expense: false) }

  def signed_cents
    self.expense ? -cents : cents
  end
end
