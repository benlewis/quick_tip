class FakeTipPayment < ActiveRecord::Base
  has_one :tip, :as => :payment

  attr_accessible :code
  validates_presence_of :code

  def self.create_with_tip!(options = {})
    client = options.delete(:client) { raise ':client necessary in create_with_tip!' }
    total_cents = options.delete(:total_cents) { 100 }
    processing_fees_cents = options.delete(:processing_fees_cents) { 35 }
    code = options.delete(:code) { SecureRandom.hex(16) }

    raise "Unexpected options in create_with_tip!: #{options.keys.join ','}" if options.any?

    fake_tip_payment = create!(:code => code)

    Tip.create!(
      :total_cents => total_cents,
      :processing_fees_cents = processing_fees_cents,
      :payment => fake_tip_payment
    )
  end

end
