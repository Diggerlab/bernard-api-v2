FactoryGirl.define do 
	factory :message do 
		user
		category %w(friend_request team_request battle_log).sample
		status 'new'
	end
end