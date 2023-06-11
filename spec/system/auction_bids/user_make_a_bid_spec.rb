require 'rails_helper'


describe 'Usuário faz um lance' do
  include ActiveSupport::Testing::TimeHelpers

  
  before :each do
    attach_img = ->(item, filename) {
      item.photo.attach(
        io: File.open(Rails.root.join("public/photo_items/#{filename}")),
        filename: filename,
        content_type: 'image/png'
      )
    }

    ######## Admins
    creator = FactoryBot.create(:creator)
    evaluator = FactoryBot.create(:evaluator)

    ######## User
    @user = FactoryBot.create(:common_user)

    ######### Categories
    fine_art = CategoryItem.create!(
      description: "Arte Plástica"
    )

    musical_instrument = CategoryItem.create!(
      description: "Musical instrument"
    )

    ######### AuctionLots for tests
    
    travel_to 2.days.ago do
      @lot_running = AuctionLot.create!(
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
      auction_item.auction_lot = @lot_running
      auction_item.save!
      
      auction_item = AuctionItem.new(
        name: "Escultura em Madeira",
        description: "Escultura única em madeira maciça, esculpida à mão",
        weight: "5000",
        width: "40",
        height: "60",
        depth: "30",
        category_item: fine_art
      )
      
      attach_img.call(auction_item, "banco-ave-741feitoamao_mg_8.jpg")
      auction_item.auction_lot = @lot_running
      auction_item.save!

      @lot_running.evaluator_user = evaluator
      @lot_running.approved!
    end

    travel_to 1.week.from_now do
      @lot_scheduled = AuctionLot.create!(
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
      auction_item.auction_lot = @lot_scheduled
      auction_item.save!
      
      auction_item = AuctionItem.new(
        name: "Guitarra Elétrica",
        description: "Guitarra elétrica de alta qualidade, perfeita para performances ao vivo",
        weight: "3500",
        width: "40",
        height: "100",
        depth: "10",
        category_item: musical_instrument
      )
      
      attach_img.call(auction_item, "7899871608841-1.jpg")
      auction_item.auction_lot = @lot_scheduled
      auction_item.save!

      @lot_scheduled.evaluator_user = evaluator
      @lot_scheduled.approved!
    end
  end


  it 'a partir da página inicial' do
    login_as(@user)

    visit root_path

    lots_running_node = page
      .find('section/div', text: 'Lotes em disputa')

    within lots_running_node do
      click_on "#{@lot_running.code}"
    end

    within '.bid-panel' do
      expect(page).to have_content 'Lance mínimo: R$ 100,00'
      expect(page).to have_field 'Lance'
      expect(page).to have_button 'Enviar Lance'
    end
  end

  it 'se estiver autenticado' do
    visit auction_lot_path(@lot_running)

    expect(page).not_to have_content 'Lance mínimo: R$ 100,00'
    expect(page).not_to have_field 'Lance'
    expect(page).not_to have_button 'Enviar Lance'
  end

  it 'e não pode ser em um lote agendado' do
    login_as(@user)

    visit auction_lot_path(@lot_scheduled)

    expect(page).not_to have_content 'Lance mínimo: R$ 100,00'
    expect(page).not_to have_field 'Lance'
    expect(page).not_to have_button 'Enviar Lance'
  end

  it 'e não pode ser um adiministrador' do
    adm = User.create!(
      cpf: '35908375004',
      email: 'romero@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd'
    )

    login_as(adm)

    visit auction_lot_path(@lot_running)

    expect(page).not_to have_content 'Lance mínimo: R$ 100,00'
    expect(page).not_to have_field 'Lance'
    expect(page).not_to have_button 'Enviar Lance'
  end

  it 'com sucesso' do
    login_as(@user)

    visit auction_lot_path(@lot_running)

    within '.bid-panel' do
      fill_in 'Lance',	with: "101"
      click_on 'Enviar Lance'
    end

    expect(current_path).to eq auction_lot_path(@lot_running)

    within '.bid-panel' do
      expect(page).to have_content 'Lance mínimo: R$ 103,00'
    end
  end

  it 'e envia valor errado' do
    login_as(@user)


    other_user = User.create!(
      cpf: '21519850085',
      email: 'david@uol.com',
      password: 'f4k3p455w0rd'
    )

    @lot_running.bids.create(bid: 101, bidder: other_user)

    visit auction_lot_path(@lot_running)

    within '.bid-panel' do
      fill_in 'Lance',	with: "102"
      click_on 'Enviar Lance'
    end

    expect(page).to have_content 'Valor de lance abaixo de mínimo!'
  end
end
