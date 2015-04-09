class ChangeSourceIdToString < ActiveRecord::Migration
  def change
    change_column :importable_transactions, :source_id, :string
    change_column :importable_accounts, :source_id, :string
  end
end
