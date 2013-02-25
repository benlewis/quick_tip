QuickTip::Application.routes.draw do
  # Static Pages
  match '/' => 'static_pages#home'

  devise_for :users

  root :to => 'static_pages#home'

end

