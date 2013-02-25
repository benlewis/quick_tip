class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.references :client, :null => false
      t.integer :cents, :null => false
      t.string :vehicle_type, :limit => 25, :null => false
      t.integer :vehicle_id, :null => false
      t.string :status, :null => false, :limit => 20

      t.timestamps
    end
    add_index :payouts, :client_id
    add_index :payouts, [:vehicle_id, :vehicle_type]
  end
end
