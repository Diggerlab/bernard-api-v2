FactoryGirl.define do 
	factory :pet do 
		user
		sequence(:name) {|n| "Hello kit#{n}"}
		gender %w(male female).sample
		exp 100
		level 10
		iq 5
		sq 15
		energy 50000
	end
end