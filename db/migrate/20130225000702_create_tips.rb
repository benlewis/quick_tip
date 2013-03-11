class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.references :client, :null => false
      t.references :tipper
      t.references :payment_method, :polymorphic => true, :null => false
      t.integer :total_cents, :null => false
      t.integer :processing_fees_cents, :null => false
      t.integer :service_cents, :null => false
      t.integer :client_cents, :null => false
      t.string :status, :null => false, :limit => 20
      t.boolean :fake, :null => false, :default => false
      t.boolean :paid, :null => false, :default => true
      t.integer :refunded_cents, :null => false, :default => 0
      t.boolean :disputed, :null => false, :default => false
      t.string :third_party_id, :null => false

      t.timestamps
    end

    add_index :tips, :client_id
    add_index :tips, [:payment_method_type, :payment_method_id]
  end
end
