class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      
      t.integer :customer_id, null: false
      t.integer :postage, null: false
      t.integer :total_prece, null: false
      t.integer :payment_method, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.string :delivery_name, null: false
      t.string :delivery_postcode, null: false
      t.string :delivery_address, null: false

      t.timestamps
    end
  end
end
