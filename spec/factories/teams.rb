FactoryGirl.define do 
	factory :team do 
		user
		pet

		status 'requested'
	end
end