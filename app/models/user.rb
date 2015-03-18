class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
          :authentication_keys => [:username]
  has_many :attendees
  has_and_belongs_to_many :interests
  has_many :events, through: :attendees
  before_save :ensure_authentication_token
  has_attached_file :avatar, :styles => { :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates :username, :presence => true,:uniqueness => {:case_sensitive => false}
  attr_accessor :login

   def ensure_authentication_token
     if authentication_token.blank?
       self.authentication_token = generate_authentication_token
     end
   end



   def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions.to_h).first
      end
    end

   def as_json(opts={})
     super(:only => [:email, :authentication_token, :username])
   end

   private
   def generate_authentication_token
     loop do
       token = Devise.friendly_token
       break token unless User.where(authentication_token: token).first
     end
   end


end
