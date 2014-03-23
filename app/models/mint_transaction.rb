class MintTransaction < ActiveRecord::Base
  belongs_to :mint_account, class_name: "MintAccount", foreign_key: "account_id", primary_key: "mint_id"

  scope :imported -> { where("imported_id is not null") }
  scope :not_imported, -> { where(imported_id: nil) }
end
