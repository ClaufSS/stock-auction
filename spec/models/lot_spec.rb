require 'rails_helper'

RSpec.describe Lot, type: :model do
  describe '#valid?' do
    context 'deve conter' do
      before :each do
        @lot = Lot.new

        @lot.valid?
      end

      it 'código' do
        expect(@lot.errors[:code]).to include 'não pode ficar em branco'
      end
      
      it 'data de início' do
        expect(@lot.errors[:start_date]).to include 'não pode ficar em branco'
      end
      
      it 'data final' do
        expect(@lot.errors[:end_date]).to include 'não pode ficar em branco'
      end
      
      it 'preço inicial' do
        expect(@lot.errors[:start_price]).to include 'não pode ficar em branco'
      end
      
      it 'lance mínimo' do
        expect(@lot.errors[:min_bid]).to include 'não pode ficar em branco'
      end
    end

    context 'data' do
      it 'de início e fim dos lances devem ser futura' do
        lot_first = Lot.new(
          start_date: 0.day.ago,
          end_date: 0.day.ago
        )

        lot_second = Lot.new(
          start_date: 1.day.ago,
          end_date: 1.day.ago
        )

        lot_first.valid?
        lot_second.valid?

        expect(lot_first.errors[:start_date]).to include "deve ser maior que #{1.day.from_now.to_date}"
        expect(lot_second.errors[:start_date]).to include "deve ser maior que #{1.day.from_now.to_date}"
        expect(lot_first.errors[:end_date]).to include "deve ser maior que #{1.day.from_now.to_date}"
        expect(lot_second.errors[:end_date]).to include "deve ser maior que #{1.day.from_now.to_date}"
      end

      it 'de fim dos lances deve suceder data de início' do
        now = 0.day.ago
        yesterday = 1.day.ago

        lot_first = Lot.new(
          start_date: now,
          end_date: yesterday
        )

        lot_second = Lot.new(
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
        lot = Lot.new code: 'rr5457'

        lot.valid?

        expect(lot.errors[:code]).to include 'deve conter 3 letras'
      end

      it '3 números' do
        lot = Lot.new code: 'fsfs45'

        lot.valid?

        expect(lot.errors[:code]).to include 'deve conter 3 números'
      end

      it '6 caracteres' do
        lot = Lot.new code: 'aj4f4gsf'

        lot.valid?

        expect(lot.errors[:code]).to include 'deve conter 6 caracteres'
      end
    end
  end

  context '#status' do
    it 'após criação deve ser #pending' do
      user = User.create!(
        cpf: '83923678045',
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd')

      lot = Lot.create!(
        code: 'abc123',
        start_date: 1.day.from_now,
        end_date: 2.day.from_now,
        start_price: 100,
        min_bid: 2,
        register_user: user
      )

      expect(lot).to be_pending 
    end
  end
end
