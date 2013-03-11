class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, :null => false, :limit => 35
      t.string :short_name, :null => false, :limit => 10
      t.float :service_pct, :null => false, :default => 5.0

      t.timestamps
    end

    add_index :clients, :name, :unique => true
    add_index :clients, :short_name, :unique => true

  end
end
