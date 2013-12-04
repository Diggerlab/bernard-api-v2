object @item
attributes :name_ch, :name_jp, :name_tw, :code, :description_ch, :description_jp, :description_tw, :coins, :gems, :sequence, :tag, :min_level, :max_level, :hot, :sale
node(:name_en) { |item| item.name }
node(:description_en) { |item| item.description }

node(:state) {|item| (@level.to_i > item.max_level && item.max_level !=0) ? 1 : 0 }



