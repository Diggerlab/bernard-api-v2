class EventTemplate <  ActiveRecord::Base
  #include ActiveUUID::UUID
  
  #attr_accessible :id, :cEnergy, :cEXP, :cHygiene, :cIQ, :cMood, :cSQ, :cState, :code, :preEnergy, :preEXP, :preHygiene, :preIQ, :preMood, :preSQ, :preState, :category, :item_id, :animEatable, :animPet, :animTool, :animFPet0, :animFPet1, :animBG, :dEnergy,:dHygiene,:dLength,:dMood, :soundEffect

  belongs_to :item, touch: true


  #HACK - for activeadmin association render in select view
  def item_id
    self.item.id if self.item
  end

end