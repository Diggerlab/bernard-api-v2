class App < Grape::API
  format :json
  formatter :json, Grape::Formatter::Rabl

  get :categories, :rabl => "category.rabl" do 
     @category = ItemCategory.first
     @items = @category.items
  end
end