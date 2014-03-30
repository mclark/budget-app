class AddBudgetToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :budgeted_cents, :integer
  end
end
