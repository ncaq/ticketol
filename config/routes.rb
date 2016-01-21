Rails.application.routes.draw do
  root to: "top#show"

  devise_for :users, skip: :registrations
  devise_scope(:user) {
    resource :registration,
             only: [:new, :create, :edit, :update],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'users/registrations',
             as: :user_registration do
      get :cancel
    end
  }
  resources :users,        :only => [:index, :show, :edit, :update]

  resources :concerts,     :only => [:index, :show, :new, :create, :edit, :update] { || member { || get 'image' } }
  resources :contacts,     :only => [:index, :show, :new, :create, :edit, :update]
  resources :events,       :only => [:show]
  resources :reservations, :only => [:index, :show, :new, :create]
end
