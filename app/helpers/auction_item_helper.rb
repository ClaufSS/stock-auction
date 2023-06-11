module AuctionItemHelper
  def formated_dimension(item)
    sizes = item.slice(:width, :height, :depth)
    
    sizes.map do |attr, value|
      precision = (value.to_i == value) ? 0 : 2
      sizes[attr] = number_with_precision(value, precision: precision)
    end

    "Dimensão (cm): #{sizes[:width]} X #{sizes[:height]} X #{sizes[:depth]}"
  end
end
