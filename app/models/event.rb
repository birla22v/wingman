class Event < ActiveRecord::Base
  has_many :attendees
  has_many :users, through: :attendees
  belongs_to :user
end
