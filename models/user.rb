#encoding: utf-8
require "digest/md5"

class User <  ActiveRecord::Base
  #include ActiveUUID::UUID
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :id, :email, :password, :password_confirmation, :remember_me, 
  #   :nickname, :status, :device_token, :language, :silence_start, :silence_period, 
  #   :code

  # email is opional for binding social network
  # validates_uniqueness_of :email
  validates_presence_of :email, :nickname
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }

  has_one :account
  has_many :authentications
  has_many :inventories
  has_many :purchases
  has_many :recharges
  has_many :quests
  has_many :pets
  has_many :messages
  has_many :unread_messages, class_name: 'Message', conditions: "status='new'"
  has_one :current_pet, :class_name => 'Pet', :conditions => "pets.status = 'active'", :order => 'updated_at desc'

  has_many :racings
  has_many :racing_results
  has_one :racing_ranking, class_name: 'RacingRanking'
  has_one :pop_ranking, class_name: 'PopRanking'
  has_one :pop_game_point, class_name: 'GamePoint', conditions: "game='pop'"
  has_one :user_stat
  
  has_one :lottery_stat
  has_many :lotteries

  has_many :feedbacks
  has_many :share_logs
  has_many :savings

  has_many :friends
  has_many :friend_users, through: :friends
  has_many :promo_codes, class_name: 'UserPromoCode'

  before_validation :generate_default_values, on: :create
  before_create :create_code
  after_create :create_account
  after_create :discard_users_and_pets, if: ->(user) {user.device_token.present?}

  alias_attribute :name, :nickname

  before_save :continuous_log_in

  def inactive?
    self.status == 'inactive'
  end

  def active?
    self.status == 'active'
  end

  def robot?
    self.status == 'racing-bot'
  end

  def silent_now?
    if silence_period.to_i > 0 && !silence_start.nil?
      hour_now = Time.now.utc.hour
      return true if hour_now >= silence_start && hour_now <= (silence_start + silence_period)
    end
    return false
  end

  # http://www.rfc-editor.org/rfc/bcp/bcp47.txt#
  def lang
    ApplicationController.helpers.lang_to_short(self.language)
  end

  def assure_code!
    if self.code.blank? 
      self.code = generate_code 
      self.save!
    end
  end

  def generate_code
    code = loop do 
      code = "u#{Array.new(7){[*2..9, *'a'..'h', *'j'..'k', *'m'..'n', *'p'..'z'].sample}.join}"
      break code unless User.find_by_code(code)
    end
  end

  private

  def continuous_log_in
    if self.current_sign_in_at_changed?
      # If user's last login is before yesterday, 
      # then reset continual days from start.
      if self.last_sign_in_at.blank? || (self.last_sign_in_at < (Date.today-1).beginning_of_day)
        self.sign_in_continual_days = 1
      # If user's last login is on yesterday, and it's the first day of today 
      # then add 1 day to continual days.
      elsif self.last_sign_in_at < Date.today.beginning_of_day
        self.sign_in_continual_days += 1
      # assign initial value 
      elsif self.sign_in_continual_days == 0 && self.sign_in_count > 0 
        self.sign_in_continual_days = 1  
      end
    end
  end

  def generate_default_values
    self.password = random_password if self.password.blank? 
    self.password_confirmation = self.password if self.password_confirmation.blank? 
    self.email = random_email if self.email.blank?
  end

  # TODO initial money
  def create_account
    Account.create(user_id: self.id, gems: 20, coins: 1700)
  end

  def random_password
    Digest::MD5.hexdigest "#{self.id}-#{Time.now.to_s}"
  end

  def random_email
    prefix = Digest::MD5.hexdigest "#{self.id}-#{Time.now.to_s}-@@@"
    "u#{prefix}@fake-email.com"
  end

  def discard_users_and_pets
    users = User.where("device_token=? and id <> ?", self.device_token, self.id)
    users.update_all status: 'inactive'
    Pet.where(user_id: users).update_all status: 'inactive'
  end
   
  def create_code 
    self.code = generate_code 
  end

end
