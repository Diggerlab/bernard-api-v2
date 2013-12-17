class PetLevel < ActiveRecord::Base
  #include ActiveUUID::UUID

  attr_accessible :min_exp, :max_exp, :level, :stage
end