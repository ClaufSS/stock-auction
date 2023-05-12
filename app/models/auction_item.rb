class AuctionItem < ApplicationRecord
  belongs_to :category_item
  has_one_attached :photo

  validates :code, :name, :description, :photo, :weight, :width, :height, :depth, presence: true

  before_validation :generate_aleatory_code


  private

  def generate_aleatory_code
    self.code = SecureRandom.alphanumeric(10)
  end
end
