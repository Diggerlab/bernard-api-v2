object @category => 'category'
attributes :name_ch, :name_jp, :name_tw, :code, :items_count, :description_jp, :description_ch, :description_tw
node(:name_en) {|category| category.name }
node(:description_en) {|category| category.description }

child @items.to_a do |item| 
  extends "show"
end
