class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, :null => false, :limit => 35
      t.decimal :qt_pct, :null => false, :default => 0.05

      t.timestamps
    end
  end
end
