class Item < ActiveRecord::Base
  #include ActiveUUID::UUID
#

  # has_attached_file :icon, :styles => { :thumb => "100x100>" }, :default_url =>  "/assets/item_blank.png", 
  #  :url => "/upload/:class/:attachment/:id/:style_:hash.:extension", :hash_secret => "bErnArd"

  # validates_presence_of :name, :item_category_id, :code
  # validates_uniqueness_of :code

  # belongs_to :item_category, counter_cache: true, touch: true
  # has_one :event_template

  # scope :default_levels, where(max_level: 0, min_level: 0)

  # def storage_type
  #   self.item_category.storage_type
  # end

  # def pocket_type?
  #   self.storage_type == 'pocket'
  # end

  # def slot_type?
  #   self.storage_type == 'slot'
  # end

  # def coin_type?
  #   self.storage_type == 'coin'
  # end

  # def purchase_by_coin?
  #   self.coins > 0
  # end

  # def purchase_by_gem?
  #   self.gems > 0
  # end

  # def icon_by_code
  #   "ic-#{self.code}.png"
  # end

  # def coins_purchase?
  #   self.tag == 'coins' && self.item_category.code == 'coins'
  # end

  # def gems_purchase?
  #   self.tag == 'gems' && self.item_category.code == 'gems'
  # end

  # # special item to find escaping pet back
  # def tracker?
  #   self.code == 'tracker'
  # end

  
end