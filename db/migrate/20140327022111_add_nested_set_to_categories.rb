class AddNestedSetToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :lft, :integer
    add_column :categories, :rgt, :integer
    add_column :categories, :depth, :integer

    add_index :categories, :lft
    add_index :categories, :rgt
    add_index :categories, :depth
  end
end
