FactoryGirl.define do 
	factory :authentication do 
		user
		provider 'sina'
		sequence(:uid) {|n| "11111111#{n}"}
		token 'sd#$)($fsdljf234234kjhjklkshdf'
		token_secret 'jklsdjlfls;diof'
	end
end