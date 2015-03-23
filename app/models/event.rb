class Event < ActiveRecord::Base
  has_many :attendees
  has_many :users, through: :attendees
  has_attached_file :creator_avatar, :styles => { :medium => "300x300>",:thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :creator_avatar, :content_type => /\Aimage\/.*\Z/
end
