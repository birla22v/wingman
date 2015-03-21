class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

  #before_action :set_location!

  def authenticate_user_from_token!
     user_token = request.headers['authentication-token']
     user_token ||= params[:auth_token].presence
     user       = user_token && User.find_by_authentication_token(user_token)

     if user
       # Notice we are passing store false, so the user is not
       # actually stored in the session and a token is needed
       # for every request. If you want the token to work as a
       # sign in token, you can simply remove store: false.
       sign_in user, store: false
     else
       render json: { :error => "Authentication Failure!" },
              status: :unauthenticated
     end
   end

   def set_location!
     user_lat = params[:latitude].presence
     user_long = params[:longitude].presence
     @user = current_user
     if user_lat && user_long
       @user.update_attribute(:latitude,user_lat)
       @user.update_attribute(:longitude,user_long)
     else
       location = request.location
       @user.update_attribute(:latitude,location.data['latiitude'])
       @user.update_attribute(:longitude,location.data['longitude'])
     end
   end

   protected

   def configure_permitted_parameters
     devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
     devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
     devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
    end


   rescue_from ActiveRecord::RecordNotFound do
     render json: nil, status: :not_found
   end
  end
