class CreateFakeTipPayments < ActiveRecord::Migration
  def change
    create_table :fake_tip_payments do |t|
      t.string :code, :null => false, :limit => 32

      t.timestamps
    end
  end
end
