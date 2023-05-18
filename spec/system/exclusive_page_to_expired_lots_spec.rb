require 'rails_helper'


describe 'Página especial para lotes expirados' do
  include ActiveSupport::Testing::TimeHelpers


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
      cpf: '93892321043',
      email: 'gasparzinho@gmail.com',
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

    ######### Lots for tests
    
    travel_to 1.week.ago do
      @without_offer_lot = Lot.create!(
        code: 'eLe110',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid: 2,
        register_user: creator
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
      auction_item.save!
      auction_item.lot = @without_offer_lot

      @without_offer_lot.approver_user = approver
      @without_offer_lot.approved!
      @without_offer_lot.save!
    end

    travel_to 1.week.ago do
      @with_offer_lot = Lot.create!(
        code: '000art',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid: 2,
        register_user: creator
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
      auction_item.save!
      auction_item.lot = @with_offer_lot

      @with_offer_lot.approver_user = approver
      @with_offer_lot.approved!
      @with_offer_lot.user_player = user
      @with_offer_lot.offer = 101
      @with_offer_lot.save!
    end

    travel_to 1.week.from_now do
      @lot_scheduled = Lot.create!(
        code: 'MUS248',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid: 2,
        register_user: creator
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
      auction_item.save!
      auction_item.lot = @lot_scheduled

      @lot_scheduled.approver_user = approver
      @lot_scheduled.approved!
      @lot_scheduled.save!
    end
  end


  context 'link é visto' do
    it 'por administrador' do
      admin = User.create!(
        cpf: '25664836040',
        email: 'adalbertojr@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )

      login_as(admin)
      visit root_path

      within 'header nav' do
        expect(page).to have_link 'Lotes expirados'
      end  
    end

    it 'apenas para administradores' do
      user = User.create!(
        cpf: '99204907096',
        email: 'geovana@gmail.com',
        password: 'f4k3p455w0rd'
      )

      login_as(user)
      visit root_path

      within 'header nav' do
        expect(page).not_to have_link 'Lotes expirados'
      end  
    end
  end

  it 'a partir da tela inicial' do
    admin = User.create!(
      cpf: '25664836040',
      email: 'adalbertojr@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd'
    )

    login_as(admin)
    visit root_path

    within 'header nav' do
      click_on 'Lotes expirados'
    end

    expect(current_path).to eq expired_lots_path
    expect(page).to have_link "#{@without_offer_lot.code}"
  end

  it 'não deve ter lotes em adamento ou futuros' do
    admin = User.create!(
      cpf: '25664836040',
      email: 'adalbertojr@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd'
    )

    login_as(admin)
    visit expired_lots_path

    #expect(page).not_to have_link "#{@running_lot.code}"
    expect(page).not_to have_link "#{@lot_scheduled.code}"
  end
end
