class EventsController < ApplicationController
  before_action :authenticate_user_from_token!
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
    @event = @user.events.create(:venue=>event_params[:venue],
                                 :latitude =>event_params[:latitude],
                                 :longitude =>event_params[:longitude],
                                 :start_time_string => event_params[:start_time_string],
                                 :end_time_string => event_params[:end_time_string],
                                 :wingman_gender => event_params[:wingman_gender])
    #convert into string object?
    # @event.update(:start_time => event_params[:start_time].to_datetime,
    #               :end_time => event_params[:end_time].to_datetime)
    @event.update_attributes(:creator_id => @user.id,
                             :num_people => 1,
                             :creator_gender => @user.gender,
                             :user_id => @user.id)
    #set_location
    interests=[]
    @user.interests.count.times do |i|
        interests<< @user.interests[i].name
    end
    @event.update_attribute(:creator_interests, interests.join(", "))
    @event.users << @user
    if @event.save
      render json: {:event=>@event}, status: :ok
    else
      render json: {:error => @event.errors}, status: :unprocessable_entity
    end
  end

  def favorite
    @event = Event.find(params[:id])
    if @user.favorite_events.where("event_id = ?",@event.id).length == 0
      @user.favorite_events << FavoriteEvent.create(:user_id => @user, :event_id => @event.id)
    end
    render json: {:favorite_events => @user.favorite_events}, status: :ok
  end

  def unfavorite
    @event = Event.find(params[:id])
    if @user.favorite_events.where("event_id = ?",@event.id).length != 0
      @fav_event =@user.favorite_events.where("event_id = ?",@event.id)
      @user.favorite_events.delete(@fav_event)
    end
    render json: {:favorite_events => @user.favorite_events}, status: :ok
  end

  def index
    radius = params[:radius]

    @events = Event.where("wingman_gender = ? OR wingman_gender is NULL",@user.gender)
    #if user has event created that are active
    if @user.events.count > 0
    #spit back events where wingman gender is creator gender and seeking gender is user gender
      # gender = @user.events.uniq.pluck(:wingman_gender)
      gender = @user.events.pluck(:wingman_gender).uniq
      if gender.length == 1
      @events = @events.where("creator_gender = ?", @user.events.last.wingman_gender)
      end
    end
    #@events = @events.where("end_time > ? AND num_people < ?",DateTime.now,2)
    @events = @events.where("num_people < ?",2)
    #distance from event
    # user_lat = @user.latitude
    # user_long = @user.longitude
    # @events.count.times do |i|
    #   event_lat = @events[i].latitude
    #   event_long = @events[i].longitude
    #   if user_lat && user_long
    #     distance = Geocoder::Calculations.distance_between([user_lat,user_long], [event_lat,event_long])
    #     @events[i].update_attribute(:distance, distance)
    #   else
    #     @events[i].update_attribute(:distance, nil)
    #   end
    # end
    # if radius
    #   @events = @events.where("distance < ?",radius)
    # end

    if @events
      # render json: {:events => @events.as_json(:include=>{:user => {:methods => [:avatar_url]}})}, status: :ok
      render json: {:events => @events.as_json(:include=>:user)}, status: :ok

    else
      render json: {:error => @events.errors}, status: :unprocessable_entity
    end
  end

  def join
    @event = Event.find(params[:id])
    #if you already have an event at that time, you can't join it
    if !@event.attendees.include?(@user) && @user.id!=@event.creator_id && @event.num_people < 2
      @event.attendees << Attendee.create(:event_id => @event.id, :user_id => @user.id)
      @event.update_attribute(:num_people, (@event.num_people+=1))
      render json: {:attendees => @event.attendees}
    else
      render json: {:message => "You're already a part of event or event is full"}
    end
  end

  private
  def event_params
    params.require(:event).permit(:venue,:latitude, :longitude, :start_time, :end_time,
                    :wingman_gender, :radius, :start_time_string, :end_time_string)
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
