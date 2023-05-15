require 'rails_helper'

RSpec.describe AuctionItem, type: :model do
  describe '#valid?' do
    context 'deve conter' do
      it 'nome' do
        item = AuctionItem.new

        item.valid?

        expect(item.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'descrição' do
        item = AuctionItem.new

        item.valid?
        
        expect(item.errors[:description]).to include 'não pode ficar em branco'
      end

      it 'peso' do
        item = AuctionItem.new

        item.valid?
        
        expect(item.errors[:weight]).to include 'não pode ficar em branco'
      end

      it 'largura' do
        item = AuctionItem.new

        item.valid?
        
        expect(item.errors[:width]).to include 'não pode ficar em branco'
      end

      it 'altura' do
        item = AuctionItem.new

        item.valid?
        
        expect(item.errors[:height]).to include 'não pode ficar em branco'
      end

      it 'profundidade' do
        item = AuctionItem.new

        item.valid?
        
        expect(item.errors[:depth]).to include 'não pode ficar em branco'
      end

      it 'foto' do
        item = AuctionItem.new

        item.valid?
        
        expect(item.errors[:photo]).to include 'não pode ficar em branco'
      end
    end

    context 'deve gerar código' do
      it 'automaticamente antes da validação' do
        item = AuctionItem.new

        item.valid?

        expect(item.code).not_to be nil
      end

      it 'e deve ser único' do
        first_item = AuctionItem.new
        second_item = AuctionItem.new

        first_item.valid?
        second_item.valid?

        expect(first_item.code).not_to be second_item.code
      end

      it 'e deve conter 10 caracteres' do
        item = AuctionItem.new

        item.valid?

        expect(item.code.length).to be 10
      end

      it 'e deve ser gerado aleatoriamente' do
        item = AuctionItem.new

        allow(SecureRandom).to receive(:alphanumeric).with(10).and_return 'abC34D6789e'
        item.valid?

        expect(item.code).to eq 'abC34D6789e'
      end

      it 'e não deve mudar depois de criado' do
        attach_img = ->(item, filename) {
          item.photo.attach(
            io: File.open(Rails.root.join("public/photo_items/#{filename}")),
            filename: filename,
            content_type: 'image/png'
          )
        }

        
        musical_instrument = CategoryItem.create!(
          description: "Musical instrument"
        )

        auction_item = AuctionItem.new(
          name: "Violão Acústico",
          description: "Violão de cordas de aço, perfeito para músicos iniciantes",
          weight: "1500",
          width: "100",
          height: "10",
          depth: "40",
          category_item: musical_instrument
        )

        attach_img.call(auction_item, "-CG-162-C-1.jpg")
        auction_item.save!
        current_code = auction_item.code
        auction_item.valid?

        expect(current_code).to eq auction_item.code
      end
    end
  end
end
