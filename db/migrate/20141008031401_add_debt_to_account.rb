class AddDebtToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :debt, :boolean, default: false
  end
end
