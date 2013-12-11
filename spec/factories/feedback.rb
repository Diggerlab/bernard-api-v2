FactoryGirl.define do 
  factory :feedback do 
    user
    content 'it is good'
    contact 'example@email.com' 
  end
end