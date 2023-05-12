class CategoryItem < ApplicationRecord
  validates :description, presence: true
end
