class FakePayoutVehicle < ActiveRecord::Base
  has_one :payout, :as => :vehicle

  attr_accessible :code
  validates_presence_of :code

  def self.create_with_payout!(options = {})
    client = options.delete(:client) { raise ':client necessary in create_with_payout!' }
    cents = options.delete(:cents) { raise ':cents necessary in create_with_payout!' }
    code = options.delete(:code) { SecureRandom.hex(16) }

    raise "Unexpected options in create_with_payout!: #{options.keys.join ','}" if options.any?

    fake_payout_vehicle = create!(:code => code)

    Payout.create!(
      :client => client,
      :cents => cents,
      :vehicle => fake_payout_vehicle
    )
  end

end
