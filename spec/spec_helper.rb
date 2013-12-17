require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'active_record'
require 'factory_girl'

require './app/models/event_template.rb'
require './app/models/item.rb'
require './app/models/item_category.rb'
require './app/models/system_variable.rb'
require './app/models/pet_level.rb'
require './app/models/user.rb'
require './app/models/pet.rb'
require './app/models/user_stat.rb'
require './spec/factories/users.rb'

require File.expand_path("../factories/item_categories", __FILE__)

#require 'your_gem_name' # and any other gems you need

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  host:     'localhost',
  username: 'bernard',
  password: 'bernard',
  database: 'bernard_test'
)

RSpec.configure do |config|
  # some (optional) config here
  config.include FactoryGirl::Syntax::Methods
end
