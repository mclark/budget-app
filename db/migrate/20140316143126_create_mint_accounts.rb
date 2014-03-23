class CreateMintAccounts < ActiveRecord::Migration
  def change
    create_table :mint_accounts do |t|
      t.integer :mint_id
      t.integer :imported_id
      t.string :name

      t.timestamps
    end
  end
end
