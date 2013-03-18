class TipsController < ApplicationController
  layout 'marketing'
  before_filter :load_client

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

  protected

  def load_client
    @client = Client.find_by_short_name(params[:short_name])
  end

end