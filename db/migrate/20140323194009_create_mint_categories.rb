class CreateMintCategories < ActiveRecord::Migration
  def change
    create_table :mint_categories do |t|
      t.integer :imported_id
      t.string :name
      t.integer :import_count

      t.timestamps
    end
  end
end
