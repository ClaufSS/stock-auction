require 'rails_helper'


describe 'Administrador cria lote, adiciona itens' do
  before :each do
    attach_img = ->(item, filename) {
      item.photo.attach(
        io: File.open(Rails.root.join("public/photo_items/#{filename}")),
        filename: filename,
        content_type: 'image/png'
      )
    }
    
    @user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

    @musical_instrument = CategoryItem.new(
      description: "Instrumento Musical"
    )

    @auction_item = AuctionItem.new(
      name: "Violão Acústico",
      description: "Violão de cordas de aço, perfeito para músicos iniciantes",
      weight: "1500",
      width: "100",
      height: "10",
      depth: "40",
      category_item: @musical_instrument
    )
    
    attach_img.call(@auction_item, "-CG-162-C-1.jpg")
    @auction_item.save!
    
    @lot = AuctionLot.create!(
      code: 'abc123',
      start_date: 1.day.from_now,
      end_date: 2.day.from_now,
      start_price: 100,
      min_bid_diff: 2,
      creator_user: @user
    )

    @lot.auction_items << @auction_item
  end


  context 'e remove item' do
    it 'a partir da página' do
      login_as(@user)
      visit auction_lot_path(@lot)

      within 'details' do
        page.click

        expect(page).to have_content "Violão Acústico - #{@auction_item.code}"

        node = page
          .find('li', text: "Violão Acústico - #{@auction_item.code}")
          .find(:xpath, '..')

        within node do
          expect(page).to have_button 'Remover'
        end
      end
    end

    it 'com sucesso' do
      login_as(@user)
      visit auction_lot_path(@lot)

      within 'details' do
        page.click

        node = page
          .find('li', text: "Violão Acústico - #{@auction_item.code}")
          .find(:xpath, '..')

        within node do
          click_on 'Remover'
        end
      end

      expect(current_path).to eq auction_lot_path(@lot)

      within 'details' do
        page.click

        expect(page).not_to have_content "Violão Acústico - #{@auction_item.code}"
      end
    end
  end
end
