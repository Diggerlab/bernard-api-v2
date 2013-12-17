
#config.ru
require 'grape'
require 'active_record'
require 'rspec'
require 'factory_girl'

require 'grape/rabl'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'builder'

require './app/models/event_template.rb'
require './app/models/item.rb'
require './app/models/item_category.rb'
require './app/models/system_variable.rb'
require './app/models/pet_level.rb'
require './app/models/user.rb'
require './app/models/pet.rb'
require './app/models/user_stat.rb'


use Rack::Config do |env|
  env['api.tilt.root'] = '/Users/daneil/APP/bernard-api-v2/app/views'
end
ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  host:     'localhost',
  username: 'bernard',
  password: 'bernard',
  database: 'bernard'
)

class App < Grape::API
  format :json
  formatter :json, Grape::Formatter::Rabl
  version 'v2', using: :path
   helpers do
    def current_user
      @current_user ||= User.authorize!(env)
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end
  end

    resource :sync do 
      resource :users_and_pets do
        post do
          params[:user]['status'] = 'generated'
          @user = User.create!(params[:user])
          @pet = @user.pets.create!(params[:pet])
          # OP: initial items with new user 
          @items = Item.where(code: ['hamburger', 'apple', 'book-I', 'swordfish', 'barbell', 'lollipop-red', 'mushroom'])
        end

        put ':id' do
          if params[:reset_pet_id].present?
            current_user.pets.find(params[:reset_pet_id]).update_attributes! status: 'inactive'
          end

          @unread_messages = current_user.unread_messages
          @pet = current_user.pets.find_or_initialize_by_id(params[:id])
          @pet.update_attributes! params[:pet]

          user_settings = {}
          %w(device_token language silence_start silence_period nickname).each do |key|
            user_settings.merge!({key.to_sym => params[key.to_sym]}) if params[key.to_sym]
          end
          @pet.user.update_attributes! user_settings
          @pet.user.assure_code!
          UserStat.sync @pet.user
        end
      end
      
      get :event_templates, :rabl => 'v2/sync/event_templates/index.rabl' do
        @templates = EventTemplate.all
      end

      get :pet_levels, :rabl => 'v2/sync/pet_levels/index.rabl' do
        @pet_levels = PetLevel.all
      end

      get :versions, :rabl => 'v2/sync/versions/index.rabl' do
        @base_build = SystemVariable.base_build
        @latest_build = SystemVariable.latest_build
        @latest_version_name = SystemVariable.latest_version_name
        @latest_version_desc = SystemVariable.latest_version_desc
      end

      get :user_stats, :rabl => 'v2/sync/user_stats/index.rabl' do
         @stat = User.first.user_stat || UserStat.sync(User.first, false) 
      end
    end
end
run App.new
