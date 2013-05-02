class TipsController < ApplicationController
  layout 'tip'
  before_filter :load_client_from_short_name

  def index
    @stripe_card = StripeCard.new(:charge_client => @client)
  end

  def create
    @stripe_card = StripeCard.create params[:stripe_card].merge(:charge_client => @client)

    if @stripe_card.errors.any?
      render :action => :index
    else
      render :text => @stripe_card.to_json
    end
  end

end