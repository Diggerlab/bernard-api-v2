require File.expand_path('../application', __FILE__)
# class App < Grape::API
#   version 'v2', using: :path
#   format :json
#   formatter :json, Grape::Formatter::Rabl

#   get :categories, :rabl => "category.rabl" do 
#      @category = ItemCategory.first
#      @items = @category.items
#   end
# end

run App.new