require 'rails_helper'

RSpec.describe CategoryItem, type: :model do
  describe '#valid' do
    it 'deve conter descrição' do
      category = CategoryItem.new

      category.valid?

      expect(category.errors[:description]).to include 'não pode ficar em branco'
    end
  end
end
