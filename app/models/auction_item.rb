class AuctionItem < ApplicationRecord
  belongs_to :category_item
  has_one_attached :photo
end
