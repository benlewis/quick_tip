class StripeCard < ActiveRecord::Base
  belongs_to :tipper
  has_many :tips

  attr_accessor :charge_amount, :charge_description, :charge_client
  attr_accessor :credit_card_number

  # attr_accessible :last4, :cc_type, :exp_month, :exp_year, :fingerprint, :country,
  #     :name, :address_line1, :address_line2, :address_city, :address_state, :address_zip, :address_country,
  #     :cvc_check, :address_line1_check, :address_zip_check, :fake, :tipper

  attr_accessible :charge_amount, :charge_description, :charge_client, :credit_card_number,
    :exp_month, :exp_year, :name

  validates_presence_of :charge_amount, :charge_client, :credit_card_number,
    :exp_month, :exp_year, :name

  validate :create_token_and_charge
  validates_presence_of :last4, :cc_type, :exp_month, :exp_year, :country, :fingerprint
  after_create :create_tip

  def display
    'Credit Card'
  end

  def create_tip
    return unless @charge_response
    tip_params = filter_tip_params_from_response
    Tip.create! tip_params.merge(:client => @charge_client, :payment_method => self)
  end

  def create_token_and_charge
    return unless @credit_card_number && @charge_amount
    @charge_amount = @charge_amount.to_i

    errors.add(:charge_amount, "Minimum payment amount is 50 cents") if @charge_amount < 50
    errors.add(:charge_client, "Missing client") unless @charge_client && @charge_client.is_a?(Client)
    return if errors.any?

    begin
      response = Stripe::Customer.create(
        :description => 'Placeholder Customer',
        :card => {
          :number => @credit_card_number,
          :exp_month => exp_month,
          :exp_year => exp_year,
          :name => name
        },
      )
      set_card_params_from_response response

      @charge_response = Stripe::Charge.create(
        :amount => @charge_amount,
        :currency => 'usd',
        :description => @charge_description,
        :customer => stripe_id
      )

    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      #e.http_status
      # err[:type]
      # err[:code]
      # err[:param]
      # err[:message]
      errors.add(:base, "#{err[:message]}")
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      errors.add(:base, "Parameter error contacting payment service")
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      errors.add(:base, "Authentication error contacting payment service")
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      errors.add(:base, "Error contacting payment service")
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      errors.add(:base, "Generic error charging card")
    end
  end

  def set_card_params_from_response(response)
    # "card": {
    #     "object": "card",
    #     "last4": "4242",
    #     "type": "Visa",
    #     "exp_month": 8,
    #     "exp_year": 2014,
    #     "fingerprint": "Wky4gIcxka7OZjnQ",
    #     "country": "US",
    #     "name": null,
    #     "address_line1": null,
    #     "address_line2": null,
    #     "address_city": null,
    #     "address_state": null,
    #     "address_zip": null,
    #     "address_country": null,
    #     "cvc_check": null,
    #     "address_line1_check": null,
    #     "address_zip_check": null
    #   },

    fake = !response.livemode
    card = response.active_card
    self.stripe_id = response.id
    self.last4 = card.last4
    self.cc_type = card.type
    self.exp_month = card.exp_month
    self.exp_year = card.exp_year
    self.fingerprint = card.fingerprint
    self.country = card.country
    self.name = card.name
    self.address_line1 = card.address_line1
    self.address_line2 = card.address_line2
    self.address_city = card.address_city
    self.address_zip = card.address_zip
    self.address_country = card.address_country
    self.cvc_check = card.cvc_check || 'unchecked'
    self.address_line1_check = card.address_line1_check || 'unchecked'
    self.address_zip_check = card.address_zip_check || 'unchecked'
    self.fake = fake
  end

  def filter_tip_params_from_response
    # #<Stripe::Charge id=ch_1QqqrCIMbOlvpZ 0x00000a> JSON: {
    #   "id": "ch_1QqqrCIMbOlvpZ",
    #   "object": "charge",
    #   "created": 1362882290,
    #   "livemode": false,
    #   "paid": true,
    #   "amount": 100,
    #   "currency": "usd",
    #   "refunded": false,
    #   "fee": 0,
    #   "fee_details": [
    #
    #   ],
    #   "card": {
    #     "object": "card",
    #     "last4": "4242",
    #     "type": "Visa",
    #     "exp_month": 8,
    #     "exp_year": 2014,
    #     "fingerprint": "Wky4gIcxka7OZjnQ",
    #     "country": "US",
    #     "name": null,
    #     "address_line1": null,
    #     "address_line2": null,
    #     "address_city": null,
    #     "address_state": null,
    #     "address_zip": null,
    #     "address_country": null,
    #     "cvc_check": null,
    #     "address_line1_check": null,
    #     "address_zip_check": null
    #   },
    #   "failure_message": null,
    #   "amount_refunded": 0,
    #   "customer": null,
    #   "invoice": null,
    #   "description": "My First Test Charge (created for API docs)",
    #   "dispute": null
    # }

    tip_params = {
      :third_party_id => @charge_response.id,
      :fake => !@charge_response.livemode,
      :total_cents => @charge_response.amount,
      :processing_fees_cents => @charge_response.fee
    }

    tip_params
  end

end

