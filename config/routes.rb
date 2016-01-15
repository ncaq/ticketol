Rails.application.routes.draw do
  root to: "top#show"

  devise_for :users, controllers: {
               registrations: 'users/registrations'
             }
  resources :users,        :only => [:index, :show, :edit, :update]

  resources :concerts,     :only => [:index, :show, :new, :create, :edit, :update] { || member { || get 'image' } }
  resources :contacts,     :only => [:index, :show, :new, :create, :edit, :update]
  resources :events,       :only => [:show]
  resources :reservations, :only => [:index, :show, :new, :create]
end
