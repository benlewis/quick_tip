class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_client
    @logged_in_client = if current_admin_user.super_admin?
      Rails.logger.info session.keys.join(',')
      Rails.logger.info session.values.join(',')

      Rails.logger.info "session[:client_id] = #{session[:client_id]}"
      client = Client.find_by_id session[:client_id]
      Rails.logger.info "Found client #{client.name}" if client

      client
    else
      current_admin_user.client
    end
    Rails.logger.info "Client is #{@logged_in_client.try(:name) || 'unset'}"
  end

  def current_client
    @logged_in_client
  end

  def load_client_from_short_name
    @client = Client.find_by_short_name(params[:short_name])
    raise "Client #{params[:short_name]} not found" if @client.nil?
  end

  def api_response(object)
    raise "Invalid object for api_response" unless object.respond_to?(:errors)
    response = if object.errors.any?
      {
        :status => 'error',
        :code => 422,
        :errors => object.errors.map do |attribute, error|
            {
              :attribute => attribute,
              :message => error
            }
          end,
        :object => object
      }
    else
      {
        :status => 'ok',
        :code => 200,
        :object => object
      }
    end

    render :json => JSON.pretty_generate(JSON.parse(response.to_json)), :status => response[:code]
  end


end
