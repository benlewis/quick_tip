ActiveAdmin.register Tip do
  scope_to do
    # unless current_admin_user.super_admin?
    #   current_admin_user.client
    # end
    @logged_in_client
  end

  config.clear_action_items!

  index do
    column :id
    if current_admin_user.super_admin?
      column 'Client' do |tip|
        tip.client.name
      end
    end
    column 'Payment Method', :payment_method do |tip|
      tip.payment_method.display
    end
    column 'Total', :total_cents do |tip|
      number_to_currency tip.total_cents / 100.0
    end
    column 'Processing Fees', :processing_fees_cents do |tip|
      number_to_currency tip.processing_fees_cents / 100.0
    end
    column 'Service Cut', :service_cents do |tip|
      number_to_currency tip.service_cents / 100.0
    end
    column 'Client Cut', :client_cents do |tip|
      number_to_currency tip.client_cents / 100.0
    end
  end
end
