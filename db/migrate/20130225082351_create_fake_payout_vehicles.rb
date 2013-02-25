class CreateFakePayoutVehicles < ActiveRecord::Migration
  def change
    create_table :fake_payout_vehicles do |t|
      t.string :code, :null => false, :limit => 32

      t.timestamps
    end
  end
end
