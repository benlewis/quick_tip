ActiveAdmin.register Client do
  before_filter :check_super_admin
  menu :if => proc { current_admin_user.super_admin? }

  scope :all
  scope :trial
  filter :name
  filter :short_name

  member_action :login_as do
    client = Client.find(params[:id])
    session[:client_id] = client.id
    redirect_to admin_clients_path, :notice => "Logged in as #{client.name}"
  end

  collection_action :logout_as do
    session.delete :client_id
    redirect_to admin_clients_path, :notice => "Not logged in as a client"
  end


  # action_item do
  #   link_to('Login As', login_as_admin_client_path(client.name))
  # end

  member_action :pay, :method => :post do
    client = Client.find(params[:id])
    client.pay!
    redirect_to clients_admin_path, :notice => "Paid!"
  end

  collection_action :balances do
    @clients = Client.with_balance
  end

  index do
    column :name
    column :short_name
    column 'Cut', :service_pct, :sortable => :service_pct do |client|
      number_to_percentage client.service_pct, :precision => 1
    end
    column :total_earnings do |client|
      number_to_currency client.total_earnings / 100.0
    end
    default_actions
    column :login_as do |client|
      link_to('Login As', login_as_admin_client_path(client))
    end
  end

  sidebar :views do
    proc = Proc.new{|s| s.name }


    if controller.instance_variable_get(:@logged_in_client)
      div do
        span "Impersonating #{controller.instance_variable_get(:@logged_in_client).name}"
        span link_to 'Logout', logout_as_admin_clients_path
      end
    end

    ul do
      li link_to 'Clients', admin_clients_path
      li link_to 'Balances', balances_admin_clients_path
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :short_name
    end
    f.inputs "Admin" do
      f.input :service_pct, :as => :number
    end
    f.buttons
  end


end
