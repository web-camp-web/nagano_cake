class RenameTotalPreceColumnToOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :total_prece, :total_price
  end
end
