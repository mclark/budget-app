class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :account_id
      t.integer :category_id
      t.integer :transfer_id
      t.string :type
      t.date :date
      t.string :description
      t.integer :cents
      t.string :notes

      t.timestamps
    end
  end
end
