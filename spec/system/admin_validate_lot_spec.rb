require 'rails_helper'


describe 'Administrador inspeciona um lote expirado' do
  before :each do
    attach_img = ->(item, filename) {
      item.photo.attach(
        io: File.open(Rails.root.join("public/photo_items/#{filename}")),
        filename: filename,
        content_type: 'image/png'
      )
    }

    ######## User
    user = User.create!(
      cpf: '62819299008',
      email: 'rubao@yahoo.com.br',
      password: 'f4k3p455w0rd'
    )

    ######## Admins
    creator = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd'
    )

    approver = User.create!(
      cpf: '83349076050',
      email: 'reidoleilao@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd'
    )

    ######### Categories
    eletronic = CategoryItem.create!(
      description: "Eletrônico"
    )

    fine_art = CategoryItem.create!(
      description: "Arte Plástica"
    )

    musical_instrument = CategoryItem.create!(
      description: "Musical instrument"
    )

    ######### AuctionLots for tests
    travel_to 1.week.ago do
      @not_approved_lot = AuctionLot.create!(
        code: 'MUS248',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid_diff: 2,
        creator_user: creator
      )

      ######### Musical instruments
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
      auction_item.auction_lot = @not_approved_lot
      auction_item.save!

      @not_approved_lot.save!
    end

    
    travel_to 1.week.ago do
      @without_offer_lot = AuctionLot.create!(
        code: 'eLe110',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid_diff: 2,
        creator_user: creator
      )

      ######### Eletronics
      auction_item = AuctionItem.new(
        name: "Câmera Fotográfica",
        description: "Câmera profissional com lente intercambiável e recursos avançados",
        weight: "800",
        width: "15",
        height: "10",
        depth: "8",
        category_item: eletronic
      )
      
      attach_img.call(auction_item, "e2905b38d6ec704f88a29ebfbc066862.jpeg")
      auction_item.auction_lot = @without_offer_lot
      auction_item.save!

      @without_offer_lot.evaluator_user = approver
      @without_offer_lot.approved!
    end

    travel_to 1.week.ago do
      @with_offer_lot = AuctionLot.create!(
        code: '000art',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid_diff: 2,
        creator_user: creator
      )
      
      ######### Arts
      auction_item = AuctionItem.new(
        name: "Escultura de Bronze",
        description: "Escultura detalhada em bronze, representando uma figura humana",
        weight: "2500",
        width: "30",
        height: "60",
        depth: "20",
        category_item: fine_art
      )
      
      attach_img.call(auction_item, "3d3c94df-e78a-42d8-b0f5-5f0a32bb2945-szoxut.jpg")
      auction_item.auction_lot = @with_offer_lot
      auction_item.save!

      @with_offer_lot.evaluator_user = approver
      @with_offer_lot.approved!
      @with_offer_lot.winner_bidder = user
      @with_offer_lot.bids.create!(bidder: user, bid: 101)
      @with_offer_lot.save!
    end
  end


  context 'e cancela o lote' do
    it 'quando expira sem aprovação' do
      admin = User.create!(
        cpf: '25664836040',
        email: 'adalbertojr@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )
  
      login_as(admin)
      visit auction_lot_path(@not_approved_lot)

      click_on 'Cancelar Lote'

      expect(current_path).to eq auction_lot_path(@not_approved_lot)
      expect(page).to have_content 'Status: Cancelado'
    end

    it 'quando expira sem receber lance' do
      admin = User.create!(
        cpf: '25664836040',
        email: 'adalbertojr@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )
  
      login_as(admin)
      visit auction_lot_path(@without_offer_lot)

      click_on 'Cancelar Lote'

      expect(current_path).to eq auction_lot_path(@without_offer_lot)
      expect(page).to have_content 'Status: Cancelado'
    end

    it 'e lote deve sair da página de lotes expirados' do
      admin = User.create!(
        cpf: '25664836040',
        email: 'adalbertojr@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )
  
      login_as(admin)
      visit auction_lot_path(@without_offer_lot)
      click_on 'Cancelar Lote'
      visit expired_auction_lots_path

      expect(page).not_to have_link "#{@without_offer_lot.code}"
    end

    it 'e itens do lote devem ficar disponíveis para outros lotes' do
      admin = User.create!(
        cpf: '25664836040',
        email: 'adalbertojr@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )

      new_lot = AuctionLot .create!(
        code: 'qwe123',
        start_date: 2.days.from_now,
        end_date: 5.days.from_now,
        start_price: 150,
        min_bid_diff: 5,
        creator_user: admin
      )

  
      login_as(admin)
      visit auction_lot_path(@without_offer_lot)
      click_on 'Cancelar Lote'
      visit auction_lot_path(new_lot)

      within '.add-item-area' do
        category = CategoryItem.where(description: 'Eletrônico').first
        item = AuctionItem.find_by(category_item: category)

        expect(page).to have_select with_options: ["Câmera Fotográfica - #{item.code}"]
      end
    end
  end

  context 'e encerra o lote' do
    it 'quando tem lance' do
      admin = User.create!(
        cpf: '25664836040',
        email: 'adalbertojr@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )

      login_as(admin)
      visit auction_lot_path(@with_offer_lot)

      click_on 'Encerrar Lote'

      expect(current_path).to eq auction_lot_path(@with_offer_lot)
      expect(page).to have_content 'Status: Encerrado'
    end

    it 'e este deve sair da página de lotes expirados' do
      admin = User.create!(
        cpf: '25664836040',
        email: 'adalbertojr@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )

      login_as(admin)
      visit auction_lot_path(@with_offer_lot)

      click_on 'Encerrar Lote'

      expect(page).not_to have_link "#{@with_offer_lot.code}"
    end
  end
end
