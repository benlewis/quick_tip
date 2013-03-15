QuickTip::Application.routes.draw do
  devise_for :tippers

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # Static Pages
  match '/' => 'static_pages#home'

  # Tips
  controller :tips do
    get '/:short_name/', :to => :tip
    post '/:short_name/', :to => :create, :as => 'tips'
  end

  devise_for :users

  root :to => 'static_pages#home'

end

