class TipsController < ApplicationController
  layout 'marketing'

  def tip
    @client = Client.find_by_short_name(params[:short_name])
    @stripe_card_tip = StripeCard::Tip.new(@client)
  end

  def create
    @stripe_card_tip = StripeCard::Tip.new params[:stripe_card_tip]

    render :text => @stripe_card_tip.to_json
  end

end