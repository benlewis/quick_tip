class CreateStripeCards < ActiveRecord::Migration
  def change
    create_table :stripe_cards do |t|
      t.references :tipper
      t.string :stripe_id, :limit => 36
      t.string :last4, :null => false, :limit => 4
      t.string :cc_type, :null => false, :limit => 'American Express'.length
      t.integer :exp_month, :null => false
      t.integer :exp_year, :null => false
      t.string :fingerprint, :limit => 36, :null => false
      t.string :country, :null => false
      t.string :name
      t.string :address_line1
      t.string :address_line2
      t.string :address_city
      t.string :address_zip
      t.string :address_country
      t.string :cvc_check, :null => false, :limit => 15, :default => "unchecked"
      t.string :address_line1_check, :null => false, :limit => 15, :default => "unchecked"
      t.string :address_zip_check, :null => false, :limit => 15, :default => "unchecked"
      t.boolean :fake, :null => false, :default => false

      t.timestamps
    end
  end
end
