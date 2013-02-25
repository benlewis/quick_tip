class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, :null => false, :limit => 35
      t.string :short_name, :null => false, :limit => 10
      t.float :qt_pct, :null => false, :default => 0.05

      t.timestamps
    end

    add_index :clients, :name, :unique => true
    add_index :clients, :short_name, :unique => true

  end
end
