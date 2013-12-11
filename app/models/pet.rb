class Pet <  ActiveRecord::Base
  #include ActiveUUID::UUID
  
  #attr_accessible :name, :user_id, :gender, :exp, :level, :iq, :sq, :teamed, :id, :status, :mood, :energy, :hygiene, :stage, :single_force, :team_force, :racing_matches, :racing_wins_init, :racing_wins_pass, :racing_champions, :depressed, :infected, :collapsed

  # validates :status, :inclusion => %w(active inactive)
  validates_presence_of :user_id #, :name
  belongs_to :user
  has_many :teams
  has_many :teams_connected, class_name: 'Team', foreign_key: 'pet_id', conditions: "status='accepted' or status='cloned'"
  has_many :friend_pets, through: :teams, conditions: "teams.status='accepted' or teams.status='cloned'", order: 'pets.id desc'
  has_many :requested_friend_pets, source: :friend_pet, through: :teams, conditions: "teams.status='requested'"
  has_many :team_requests, class_name: 'Team', foreign_key: 'friend_pet_id', conditions: "teams.status='requested'"
  
  has_many :racings
  has_many :racing_results
  scope :alive, where(:status == 'active')

  before_create :generate_gender
  before_create :discard_old_pets
  after_update :discard_pet_in_teams
  before_save :calculate_forces

  #HACK - for activeadmin association render in select view
  def user_id
    self.user.id if self.user
  end

  def inactive?
    self.status == 'inactive'
  end 

  def active?
    self.status == 'active'
  end 

  def friend_pets_full?
    self.friend_pets.count >= 2
  end

  def all_team_pet_ids
    members = [self.id.to_s]
    self.friend_pets.each do |p|
      members << p.id.to_s
    end unless self.friend_pets.blank?
    members
    
  end
  
  private
  def generate_gender
    self.gender = %w(male female).sample if self.gender.blank?
  end

  def discard_old_pets
    self.user.pets.where(status: 'active').each do |pet|
      pet.update_attributes! status: 'inactive'
    end
  end

  def discard_pet_in_teams
    if self.status_changed? && self.inactive?
      self.friend_pets.each do |fp|
        Message.build_message({category: 'pet_inactive_notice_teammates', from_user_id: self.user.id, user_id: fp.user.id})
      end

      # to avoid lock timeout, place update statements in last order
      Team.where(pet_id: self.id).update_all status: 'inactive'
      Team.where(friend_pet_id: self.id).update_all status: 'inactive'
    end
  end

  def calculate_forces
    self.single_force = ((self.sq*0.7 + self.iq*0.3) + 10)
    self.team_force = self.single_force 
    self.friend_pets.each do |p|
      self.team_force = p.single_force if self.team_force < p.single_force
    end

  end
end