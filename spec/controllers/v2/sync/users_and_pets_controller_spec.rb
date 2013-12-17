require 'spec_helper'
require 'uuidtools'


describe 'V2::Sync::UsersAndPetsController' do

  #render_views

  context '#create' do 
    before :each do 
      # category = create(:item_category)
      # create(:item, item_category: category, code: 'apple')
      # create(:item, item_category: category, code: 'swordfish')
      # create(:item, item_category: category, code: 'barbell')

      @uid = UUIDTools::UUID.random_create
      @pid = UUIDTools::UUID.random_create
      create :user, id: @uid
      create :pet, id: @pid, user_id: @uid
      post :create, user: {id: @uid, nickname: 'whatever', device_token: '123', language: 'en'}, pet: {id: @pid, name: 'hallo'}, format: :json
      @user = assigns(:user) 
      @pet = assigns(:pet) 
      @response = response
    end

    it 'responses ok' do 
      @response.body
      @response.code.should eq '200'
    end 

    it 'initializes user and pet' do 
      result = JSON.parse(@response.body)
      # result['user']['gems'].should eq 0
      # result['user']['coins'].should eq 0
      result['user']['authentication_token'].should_not be_nil 

      @user.id.should eq @uid
      @user.status.should eq 'generated' 

      @pet.id.should eq @pid
      @pet.user.id.should eq @uid
      @pet.status.should eq 'active'
    end

    it 'has device_token' do 
      @user.device_token.should eq '123'
      
    end

    it 'has prefered language' do 
      @user.language.should eq 'en' 
      
    end

    it 'init with items' do 
      result = JSON.parse(@response.body)
      # puts result['items']
      result['items'].should_not be_nil
    end

    it 'create with code' do 
      result = JSON.parse(@response.body)
      result['user']['code'].should_not be_nil
    end
  end

  # context "#update" do
  #   before :each do 
  #     @user = create(:user)
  #     @user1 = create(:user, authentication_token: '222')
  #     @user2 = create(:user, authentication_token: '333')
      
  #   end


  #   it 'should create a new pet if not exists' do 
  #     pid = UUIDTools::UUID.random_create
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
  #     #puts response.code
  #     response.code.should eq '200'
  #     Pet.count.should eq 1
  #     Pet.last.exp.should eq 10
  #   end

    
  #   it 'should update existing pet if exists' do
  #     pid = UUIDTools::UUID.random_create
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
  #     response.code.should eq '200'
  #     Pet.count.should eq 1
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 20, gender: 'male', stage: 1}, token: @user.authentication_token, format: :json
  #     response.code.should eq '200'
  #     Pet.count.should eq 1
  #     Pet.last.exp.should eq 20
  #   end

  #   it 'reset old pet to inactive' do 
  #     pid = UUIDTools::UUID.random_create
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
  #     response.code.should eq '200'
  #     pid2 = UUIDTools::UUID.random_create
  #     post :update, id: pid2.to_s, reset_pet_id: pid.to_s, pet: {name: 'p2', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
      
  #     response.code.should eq '200'
  #     @user.pets.count.should eq 2
  #     @user.current_pet.id.should eq pid2
  #   end

  #   it 'has unread messages' do 
  #     pid = UUIDTools::UUID.random_create
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json

  #     response.code.should eq '200'
  #     JSON.parse(response.body)['pet']['user']['new_messages'].should eq 0
  #   end

  #   it 'has unread messages in tags' do 
  #     pid = UUIDTools::UUID.random_create
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json

  #     response.code.should eq '200'
  #     %w(new_messages new_system_messages new_game_messages new_team_messages).each do |message|
  #       JSON.parse(response.body)['pet']['user'][message].should eq 0 
  #     end

  #     user1 = create(:user)
  #     pet1 = create(:pet, user: user1)
  #     Team.request! pet1, Pet.find(pid)
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 11, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json

  #     response.code.should eq '200'
  #     JSON.parse(response.body)['pet']['user']['new_team_messages'].should eq 1

  #   end


  #   it 'has friends pet in team' do 
  #     user1 = create(:user)
  #     pet1 = create(:pet, user: user1)

  #     @pet = create(:pet, user: @user)
  #     create(:team, user: @user, pet: @pet, friend_user_id: user1.id, friend_pet_id: pet1.id, status: 'accepted')

  #     post :update, id: @pet.id.to_s, pet: {name: @pet.name, level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
  #     response.should be_ok
  #     JSON.parse(response.body)['pet']['teams'].count.should eq 1 
  #   end

  #   it 'reset old pet in teams' do 
  #     pet0 = create(:pet)

  #     pid = UUIDTools::UUID.random_create
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
      
  #     response.code.should eq '200'
  #     @user.current_pet.reload.id.should eq pid

  #     pet1 = Pet.find(pid)
  #     team = Team.request! pet0, pet1
  #     team.accept!

  #     pet0.friend_pets.reload.first.should eq pet1 


  #     pid2 = UUIDTools::UUID.random_create
  #     post :update, id: pid2.to_s, reset_pet_id: pid.to_s, pet: {name: 'p2', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
      
  #     response.code.should eq '200'
  #     @user.pets.count.should eq 2
  #     @user.reload.current_pet.id.should eq pid2

  #     pet0.friend_pets.reload.count.should eq 0
  #   end


  #   it 'reset pet to notice friends' do 
  #     pet0 = create(:pet)

  #     pid = UUIDTools::UUID.random_create
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
  #     response.code.should eq '200'

  #     pet1 = Pet.find(pid)
  #     team = Team.request! pet0, pet1
  #     team.accept!

  #     pid2 = UUIDTools::UUID.random_create
  #     post :update, id: pid2.to_s, reset_pet_id: pid.to_s, pet: {name: 'p2', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
  #     response.code.should eq '200'

  #     pet0.user.unread_messages.reload.map(&:category).should include 'pet_inactive_notice_teammates'

  #   end

  #   it 'gives friends pets match info' do 
  #     pet0 = create(:pet)

  #     pid = UUIDTools::UUID.random_create
  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 1, exp: 10, gender: 'male', stage: 0}, token: @user.authentication_token, format: :json
  #     response.code.should eq '200'

  #     pet1 = Pet.find(pid)
  #     team = Team.request! pet0, pet1
  #     team.accept!    

  #     post :update, id: pid.to_s, pet: {name: 'p1', level: 2, exp: 20}, token: @user.authentication_token, format: :json
  #     response.code.should eq '200'

  #     content = JSON.parse(response.body)
  #     # puts content.to_yaml
  #     content['pet']['teams'].should_not be_nil
  #   end

  #   it 'with friends authentications' do 
  #     pet0 = create(:pet, user: @user)
  #     pet1 = create(:pet, user: @user1)
  #     create(:authentication, uid:'fb1', provider: 'facebook', user: @user1)
  #     create(:authentication, uid:'weibo1', provider: 'weibo', user: @user1)

  #     team = Team.request! pet0, pet1
  #     team.accept!  

  #     post :update, id: pet0.id.to_s, pet: {name: 'p0', level: 2, exp: 20}, token: @user.authentication_token, format: :json
  #     response.code.should eq '200'

  #     content = JSON.parse(response.body)
  #     content['pet']['teams'].first['user']['authentications'].count.should eq 2
  #   end

  #   it 'update nickname' do 
  #     pet0 = create(:pet, user: @user)
  #     new_name = 'xxx'
  #     post :update, id: pet0.id.to_s, pet: {name: 'p0', level: 2, exp: 20}, nickname: new_name, language: 'zh', token: @user.authentication_token, format: :json
  #     response.code.should eq '200'
  #     content = JSON.parse(response.body)
  #     content['pet']['user']['nickname'].should eq new_name
  #     @user.reload.nickname.should eq new_name
  #   end

  #   it 'always with code' do 
  #     @user.code = nil
  #     @user.save!
  #     @user.reload.code.should be_nil
  #     pet0 = create(:pet, user: @user)
  #     put :update, id: pet0.id.to_s, token: @user.authentication_token, format: :json
  #     response.should be_ok
  #     JSON.parse(response.body)['pet']['user']['code'].should_not be_nil 
  #   end
    
  # end
end
