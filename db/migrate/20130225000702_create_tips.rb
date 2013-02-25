class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.references :client, :null => false
      t.integer :total_cents, :null => false
      t.integer :processing_fees_cents, :null => false
      t.integer :qt_cents, :null => false
      t.integer :client_cents, :null => false
      t.string :status, :null => false, :limit => 20
      t.string :payment_type, :null => false, :limit => 25
      t.integer :payment_id, :null => false

      t.timestamps
    end

    add_index :tips, :client_id
    add_index :tips, [:payment_type, :payment_id]
  end
end
