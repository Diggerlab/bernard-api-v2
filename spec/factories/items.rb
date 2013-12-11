FactoryGirl.define do 
	factory :item do 
		sequence(:name) {|n| "item #{n}"}
		sequence(:code) {|n| "item_#{n}"}
		item_category
		gems { %w(5 10 15 20 25).sample }
		min_level 0
		max_level 0
	end
end