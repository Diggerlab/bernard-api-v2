object @pet
attribute :id, :name, :level, :exp, :iq, :sq, :created_at, :status, :moode, :energy, :hygiene, :stage, :racing_matches, :racing_wins_init, :racing_wins_pass, :racing_champions, :depressed, :infected, :collapsed
child(:friend_pets => :teams) do 
	attribute :id, :name, :level, :exp, :iq, :sq, :created_at, :status, :stage, :gender, :racing_matches, :teamed, :racing_wins_pass, :racing_wins_init, :racing_champions, :mood, :energy, :hygiene, :depressed, :infected, :collapsed
	child(:user) do 
		attribute :id, :nickname, :status, :created_at
		child(:authentications) do 
			attribute :uid, :provider
		end
	end	
end

child(:user) do 
	attribute :id, :nickname, :email, :status, :created_at, :code
	node(:new_messages) { @unread_messages.count }
	node(:new_system_messages) { @unread_messages.where(category: Message.categories[:system]).count }
	node(:new_game_messages) { @unread_messages.where(category: Message.categories[:game]).count }
	node(:new_team_messages) { @unread_messages.where(category: Message.categories[:team]).count }
	node(:gems) {|u| u.account.gems }
	node(:coins) {|u| u.account.coins }
end
