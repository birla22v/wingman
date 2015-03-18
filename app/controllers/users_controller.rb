 class UsersController < ApplicationController
   before_action :authenticate_user_from_token!
  #  skip_before_filter  :verify_authenticity_token

   def show
     @user = User.find(params[:id])
     render json: { :user => @user }, status: :created
   end

   def update
     @user = User.find(params[:id])
     @user.update_attribute(:gender, user_params[:gender])
     interests = user_params[:interests].gsub(/\s+/, "").split(",")
     interests.count.times do |i|
       @interest = Interest.find_by(name:interests[i])
       binding.pry
       if @interest && !@user.interests.include?(@interest)
         @interest.users << @user
       elsif !@interest
         @user.interests.create(name: interests[i])
       end
     end
     render json: {user: @user, gender: @user.gender, interests: @user.interests}
   end

  private
   def as_json(opts={})
     super(:only => [:id, :email, :username])
   end

   def user_params
    params.require(:user).permit(:avatar, :gender, :username, :latitude, :longitude, :interests)
   end
 end
