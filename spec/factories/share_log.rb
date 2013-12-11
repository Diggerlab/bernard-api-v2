FactoryGirl.define do 
	factory :share_log do 
		user
		provider %w(sina facebook twitter).sample
		category %w(tools_share racing_share pop_share photo_share).sample
	end
end