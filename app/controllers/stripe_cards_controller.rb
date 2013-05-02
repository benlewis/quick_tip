class StripeCardsController < ApplicationController
  before_filter :load_client_from_short_name

  def create
    @stripe_card = StripeCard.create params[:stripe_card].merge(:charge_client => @client)
    api_response(@stripe_card)
  end

end