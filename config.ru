
#config.ru

require 'grape'
require 'active_record'

require 'grape/rabl'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'builder'

require './models/event_template.rb'
require './models/item.rb'
require './models/item_category.rb'

use Rack::Config do |env|
  env['api.tilt.root'] = '/Users/daneil/APP/Grape/views'
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

  get :categories, :rabl => "category.rabl" do 
     @category = ItemCategory.first
     @items = @category.items
  end
end

run App.new