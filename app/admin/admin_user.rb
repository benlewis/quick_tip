ActiveAdmin.register AdminUser do
  menu :if => proc { current_admin_user.super_admin? }
  before_filter :check_super_admin

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
      f.input :super_admin
      f.input :client
    end
    f.actions
  end
end
