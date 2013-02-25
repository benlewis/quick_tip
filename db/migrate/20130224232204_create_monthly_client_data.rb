class CreateMonthlyClientData < ActiveRecord::Migration
  def change
    create_table :monthly_client_data do |t|
      t.references :client, :null => false
      t.integer :month, :null => false
      t.integer :year, :null => false
      t.datetime :last_calculated_at
      t.integer :beginning_balance, :null => false
      t.integer :ending_balance
      t.integer :total_tips_count
      t.integer :total_tips_cents
      t.integer :total_tips_processing_fees_cents
      t.integer :total_tips_qt_cents
      t.integer :total_tips_client_cents
      t.integer :total_payouts_count
      t.integer :total_payouts_cents

      t.timestamps
    end
    add_index :monthly_client_data, :client_id
  end
end
