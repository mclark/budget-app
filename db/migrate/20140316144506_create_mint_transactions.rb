class CreateMintTransactions < ActiveRecord::Migration
  def change
    create_table :mint_transactions do |t|
      t.integer :mint_id
      t.integer :imported_id
      t.date :date
      t.string :description
      t.string :category
      t.integer :cents
      t.boolean :expense
      t.string :account
      t.integer :account_id
      t.string :notes

      t.timestamps
    end
  end
end
