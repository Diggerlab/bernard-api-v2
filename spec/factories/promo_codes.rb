FactoryGirl.define do 
	factory :promo_code do 
		code 'u-iammike'
    category 'test'
    state 'new'
    one_time_only false
    one_user_only false
    expire_at nil
	end
end
