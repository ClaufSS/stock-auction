require 'rails_helper'

RSpec.describe AuctionLot, type: :model do
  describe '#valid?' do
    context 'data' do
      it 'de início dos lances deve ser futura' do
        lot_first = AuctionLot.new(
          start_date: 0.day.ago,
        )

        lot_second = AuctionLot.new(
          start_date: 2.day.from_now,
        )

        lot_first.valid?
        lot_second.valid?

        expect(lot_first.errors[:start_date]).to include "deve ser maior que #{1.day.from_now.to_date}"
        expect(lot_second.errors[:start_date]).not_to include "deve ser maior que #{1.day.from_now.to_date}"
      end

      it 'de fim dos lances deve suceder data de início' do
        now = 0.day.ago
        yesterday = 1.day.ago

        lot_first = AuctionLot.new(
          start_date: now,
          end_date: yesterday
        )

        lot_second = AuctionLot.new(
          start_date: now,
          end_date: now
        )

        lot_first.valid?
        lot_second.valid?

        expect(lot_first.errors[:end_date]).to include "deve ser maior que #{lot_first.start_date}"
        expect(lot_second.errors[:end_date]).to include "deve ser maior que #{lot_second.start_date}"
      end
    end
    
    context 'código deve conter' do
      it '3 letras' do
        lot = AuctionLot.new code: 'rr5457'

        lot.valid?

        expect(lot.errors[:code]).to include 'deve conter 3 letras'
      end

      it '3 números' do
        lot = AuctionLot.new code: 'fsfs45'

        lot.valid?

        expect(lot.errors[:code]).to include 'deve conter 3 números'
      end

      it '6 caracteres' do
        lot = AuctionLot.new code: 'aj4f4gsf'

        lot.valid?

        expect(lot.errors[:code]).to include 'deve conter 6 caracteres'
      end
    end
  end

  describe '#approved?' do
    it 'deve conter usuário avaliador' do
      lot = FactoryBot.create(:auction_lot)

      lot.update(status: :approved)

      expect(lot.errors[:base]).to include 'É necessário fornecer o responsável pela avaliação.'
    end

    it 'avaliador não pode ser o criador' do
      creator = FactoryBot.create(:admin_user)
      lot = FactoryBot.create(:auction_lot, creator_user: creator)

      lot.update(status: :approved, evaluator_user: creator)

      expect(lot.errors[:base]).to include 'Usuário avaliador não pode ser o criador do lote!'
    end

    it 'avaliador deve ser um administrador' do
      common_user = FactoryBot.create(:common_user)
      lot = FactoryBot.create(:auction_lot)

      lot.update(status: :approved, evaluator_user: common_user)

      expect(lot.errors[:base]).to include 'Avaliador precisa ser um administrador!'
    end
  end

  it 'deve ser preenchido corretamente' do
    @lot = AuctionLot.new

    @lot.valid?
    
    expect(@lot.errors[:code]).to include 'não pode ficar em branco'      
    expect(@lot.errors[:start_date]).to include 'não pode ficar em branco'      
    expect(@lot.errors[:end_date]).to include 'não pode ficar em branco'      
    expect(@lot.errors[:start_price]).to include 'não pode ficar em branco'      
    expect(@lot.errors[:min_bid_diff]).to include 'não pode ficar em branco'
  end

  context '#status' do
    it 'após criação deve ser #pending' do
      user = User.create!(
        cpf: '83923678045',
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd')

      lot = AuctionLot.create!(
        code: 'abc123',
        start_date: 1.day.from_now,
        end_date: 2.day.from_now,
        start_price: 100,
        min_bid_diff: 2,
        creator_user: user
      )

      expect(lot).to be_pending 
    end
  end

  it 'deve limpar itens após ser cancelado' do
    attach_img = ->(item, filename) {
      item.photo.attach(
        io: File.open(Rails.root.join("public/photo_items/#{filename}")),
        filename: filename,
        content_type: 'image/png'
      )
    }
    
    creator = FactoryBot.create(:creator)
    evaluator = FactoryBot.create(:evaluator)

    musical_instrument = CategoryItem.create!(
      description: "Musical instrument"
    )

    travel_to 1.week.from_now do
      AuctionLot.create!(
        code: 'MUS248',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid_diff: 2,
        creator_user: creator
      )
    end

    lot = AuctionLot.find_by(code: 'MUS248')

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
    auction_item.auction_lot = @lot_scheduled
    auction_item.save!
    lot.auction_items << auction_item
    lot.evaluator_user = evaluator
    lot.canceled!

    expect(lot.auction_items).to eq []
  end
end
