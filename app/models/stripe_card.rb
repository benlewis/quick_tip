class StripeCard < ActiveRecord::Base
  belongs_to :tipper

  validates_presence_of :last4, :cc_type, :exp_month, :exp_year, :country, :fingerprint
  attr_accessible :last4, :cc_type, :exp_month, :exp_year, :fingerprint, :country,
    :name, :address_line1, :address_line2, :address_city, :address_state, :address_zip, :address_country,
    :cvc_check, :address_line1_check, :address_zip_check, :fake, :tipper

  def display
    'Credit Card'
  end

  def self.create_with_charge!(card_details, charge_details)
    amount = charge_details.delete(:amount) { raise "charge_details[:amount] required" }
    client = charge_details.delete(:client) { raise "charge_details[:client] required " }
    description = charge_details.delete(:description) { "Tip for #{client.name}" }
    card = card_details # TODO: Add support for Tippers to save credit cards

    raise "Minimum payment amount is 50 cents" if amount < 50

    begin
      response = Stripe::Charge.create(
        :amount => amount,
        :currency => 'usd',
        :description => description,
        :card => card
      )

      card_params = filter_card_params_from_response(response)
      stripe_card = StripeCard.create! card_params

      tip_params = filter_tip_params_from_response(response)
      tip = Tip.create! tip_params.merge(:client => client, :payment_method => stripe_card)
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Code is: #{err[:code]}"
      # param is '' in this case
      puts "Param is: #{err[:param]}"
      puts "Message is: #{err[:message]}"
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
    end

  end

  def self.filter_card_params_from_response(response)
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
    card = response.card
    card_params = {
      :last4 => card.last4,
      :cc_type => card.type,
      :exp_month => card.exp_month,
      :exp_year => card.exp_year,
      :fingerprint => card.fingerprint,
      :country => card.country,
      :name => card.name,
      :address_line1 => card.address_line1,
      :address_line2 => card.address_line2,
      :address_city => card.address_city,
      :address_zip => card.address_zip,
      :address_country => card.address_country,
      :cvc_check => card.cvc_check || 'unchecked',
      :address_line1_check => card.address_line1_check || 'unchecked',
      :address_zip_check => card.address_zip_check || 'unchecked',
      :fake => fake
    }

    card_params
  end

  def self.filter_tip_params_from_response(response)
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
      :third_party_id => response.id,
      :fake => !response.livemode,
      :total_cents => response.amount,
      :processing_fees_cents => response.fee
    }

    tip_params
  end

end
