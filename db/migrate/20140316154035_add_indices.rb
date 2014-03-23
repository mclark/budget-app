class AddIndices < ActiveRecord::Migration
  def change
    add_index :categories, :parent_id

    add_index :transactions, :account_id
    add_index :transactions, :category_id
    add_index :transactions, :transfer_id
    
    add_index :mint_accounts, :mint_id, unique: true
    add_index :mint_transactions, :mint_id, unique: true
  end
end
