class AuctionItem < ApplicationRecord
  belongs_to :category_item
  belongs_to :auction_lot, optional: true
  has_one_attached :photo

  enum :status, {available: 0, sold: 1}

  validates :code, :name, :description, :photo, :weight, :width, :height, :depth, presence: true

  before_validation :generate_aleatory_code, on: :create


  def full_description
    "#{name} - #{code}"
  end

  private

  def generate_aleatory_code
    self.code = SecureRandom.alphanumeric(10)
  end
end
