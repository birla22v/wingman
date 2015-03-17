class EventsController < ApplicationController
  before_action :set_user
  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address
  # geocoded_by :full_address   # can also be an IP address
  # after_validation :geocode          # auto-fetch coordinates

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
  end

  def create
    @user = User.find(1)
    @event = @user.events.create(event_params)
    @event.update_attribute(:creator_id, @user.id)
    @event.update_attribute(:creator_name, @user.username)
    @event.update_attribute(:creator_gender, @user.gender)
    @event.update_attribute(:creator_phone_number, @user.phone_number)
    @event.update_attribute(:creator_age, @user.age)
    set_location
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
    @events = @events.where("end_time < ?",DateTime.now)
    #distance from event
    user_lat = @user.latitude
    user_long = @user.longitude
    @events.count.times do |i|
      event_lat = @events[i].latitude
      event_long = @events[i].longitude
      distance = Geocoder::Calculations.distance_between([user_lat,user_long], [event_lat,event_long])
      @events[i].update_attribute(:distance, distance)
    end
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
    render json: {:attendees => @event.users}
  end
  # def find_address
  #   @event.venue
  # end


  private
  def event_params
    params.require(:event).permit(:venue,:latitude, :longitude, :start_time, :end_time,
                    :wingman_gender, :radius)
  end

  def set_user
    @user = current_user
  end

  def set_location
    if(event_params[:venue]!= nil && (event_params[:latitude]==nil || event_params[:longitude]==nil))
      @event.latitude,@event.longitude=Geocoder.coordinates(event_params[:venue])
    end
    if(event_params[:venue]== nil && (event_params[:latitude]!=nil && event_params[:longitude]!=nil))
      @event.venue = Geocoder.address([event_params[:latitude],event_params[:longitude]])
    end
  end
end
