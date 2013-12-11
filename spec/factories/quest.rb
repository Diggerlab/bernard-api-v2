FactoryGirl.define do 
  factory :quest do 
    user
    pet
    quest_template
    state 'new'
  end
end