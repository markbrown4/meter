Meter::Application.routes.draw do

  match "/application.manifest" => Rails::Offline

  resources :trips

  root :to => 'trips#index'

end
