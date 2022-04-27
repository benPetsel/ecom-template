# frozen_string_literal: true
# For BEN this controller keeps the create user page locked to only logged in users 
#  the routes aims devise to this controller to registration behavior 
#this post helped https://stackoverflow.com/questions/24875403/rails-only-allow-admin-user-to-create-new-users-in-rails-with-devise-no-extern
class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :authenticate_user!, :redirect_if_not_user, only: [:new, :create]
  skip_before_action :require_no_authentication
  
   #GET /resource/sign_up
   def new
     super
   end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private
  def redirect_if_not_user
    unless user_signed_in?
      flash[:error] = "Only admins can do that, please log in to access this page"
      redirect_to root_path
    end
  end

  def sign_up(resource_name, resource)
    true
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
