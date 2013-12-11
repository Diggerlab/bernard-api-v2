FactoryGirl.define do 
	factory :item_category do 
		sequence(:name) {|n| "category #{n}"}
		sequence(:code) {|n| "category_#{n}"}
		storage_type { %w(pocket slot).sample }
	end
end