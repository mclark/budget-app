class RenameMintToImport < ActiveRecord::Migration
  def change
    rename_column :mint_accounts, :mint_id, :source_id
    rename_column :mint_transactions, :mint_id, :source_id

    rename_table :mint_accounts, :importable_accounts
    rename_table :mint_transactions, :importable_transactions
    rename_table :mint_categories, :importable_categories
  end
end
