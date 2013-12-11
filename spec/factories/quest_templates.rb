FactoryGirl.define do 
	factory :quest_template do 
		name 'new temp1'
		category 'daily_login'
		code 'c1'
		award JSON.parse('{"coins": 10}')

	end
end