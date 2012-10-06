Meter::Application.routes.draw do

  match "/application.manifest" => Rails::Offline

  resources :trips do
    collection do
      get 'log'
      get 'trends'
    end
  end

  root :to => 'trips#index'

end
