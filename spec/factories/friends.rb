FactoryGirl.define do 
	factory :friend do 
		user
		provider 'weibo'
		uid '12345'
		state 'connected'
	end
end