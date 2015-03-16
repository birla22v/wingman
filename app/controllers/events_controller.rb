class EventsController < ApplicationController
  before_action :set_user
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
  end

  def create
    @event = @user.events.create(event_params)
    @event.update_attribute(:creator_id, @user.id)
    @event.update_attribute(:creator_name, @user.username)
    @event.update_attribute(:creator_gender, @user.gender)
    @event.update_attribute(:creator_phone_number, @user.phone_number)
    interests=[]
    @user.interests.count.times do |i|
        interests<< @user.interests[i].name
    end
    @event.update_attribute(:creator_interests, interests.join(", "))
    if @event.save
      render json: {:event=>@event}, status: :ok
    else
      render json: {:error => @event.errors}, status: :unprocessable_entity
    end
  end

  def index
    @events = Event.where("wingman_gender = ? OR wingman_gender is NULL",@user.gender)
    @events = @events.where("end_time > ?",DateTime.now)
    #distance from event
    user_latitude = @user.latitude
    user_longitude = @user.longitude
    if @events
      render json: {:events => @events}, status: :ok
    else
      render json: {:error => @events.errors}, status: :unprocessable_entity
    end
  end

  def join
    @event = Event.find(params[:id])
    if !@event.users.include?(@user) && @user.id!=@event.creator_id
      @event.users << @user
    end
  end

  # def show
  #   @event = Event.find(params[:id])
  #   @event_creator_name = User.find(@event.creator_id).username
  #   @event_creator_gender = User.find(@event.creator_id).gender
  #   @distance=Geocoder::Calculations.distance_between([@user.latitude,@user.longitude], [@event.latitude,@event.longitude])
  # end

  def update
  end

  private
  def event_params
    params.require(:event).permit(:venue,:latitude, :longitude, :start_time, :end_time, :wingman_gender,
                       :radius)
  end

  def set_user
    @user = current_user
  end
end
