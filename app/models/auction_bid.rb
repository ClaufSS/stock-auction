class AuctionBid < ApplicationRecord
  belongs_to :auction_lot
  belongs_to :bidder, class_name: 'User', foreign_key: :bidder_id

  validate :bid_price
  validate :bidder_user

  private

  def bid_price
    return if bid >= auction_lot.min_bid
    
    errors.add(:bid, 'Lance deve ser maior ou igual ao valor mínimo.')
  end

  def bidder_user
    return if bidder.common?

    errors.add(:bidder, 'Somente usuários comuns podem fazer um lance.')
  end
end
