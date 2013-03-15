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

end
