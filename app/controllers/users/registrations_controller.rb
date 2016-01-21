class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_create_parameters, only: [:create]

  # POST /users
  def create
    super
    if params[:is_seller]
      resource.seller_pending!
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_create_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :is_seller
  end
end
