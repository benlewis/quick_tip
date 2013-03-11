ActiveAdmin.register Client do
  menu :if => proc { current_admin_user.super_admin? }

  scope :all
  scope :trial
  filter :name
  filter :short_name

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
      number_to_currency client.total_earnings
    end
    default_actions
  end

  sidebar :views do
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
