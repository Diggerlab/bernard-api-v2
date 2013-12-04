class ItemCategory < ActiveRecord::Base
  #include ActiveUUID::UUID
  # attr_accessible :name, :description, :code, :storage_type, :name_ch, :name_jp, :name_tw, :description_ch, :description_jp, :description_tw, :sequence
  # validates_presence_of :name
  # validates :storage_type, :inclusion => { :in => %w(slot pocket coin gem)}

  has_many :items

  # alias_attribute :name_en, :name
  # alias_attribute :description_en, description
end