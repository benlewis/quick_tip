ActiveAdmin.register Client do
  scope :trial
  filter :name
  filter :short_name

  index do
    column :name
    column :short_name
    column "Cut", :qt_pct do |client|
      number_to_percentage client.qt_pct * 100, :precision => 1
    end
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :short_name
    end
    f.inputs "Admin" do
      f.input :qt_pct, :as => :number
    end
    f.buttons
  end


end
