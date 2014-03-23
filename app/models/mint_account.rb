class MintAccount < ActiveRecord::Base
  has_many :mint_transactions, foreign_key: "account_id", primary_key: "mint_id"

  scope :imported -> { where("imported_id is not null") }
  scope :not_imported, -> { where(imported_id: nil) }
end
