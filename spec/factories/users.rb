FactoryGirl.define do 
	factory :user do 
		sequence(:nickname) {|n| "Micky Mouse #{n}"}
		password '123455'
		password_confirmation {password}
		sequence(:email) {|n| "micky#{n}@email.com"}
		sequence(:authentication_token) {|n| "test#{n}"}
		status 'pending'
		sequence(:device_token ) {|n| "device_token-#{n}"}
    code '1234'
		
	end
end
