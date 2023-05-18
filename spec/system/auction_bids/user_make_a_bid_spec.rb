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

    ######## User
    @user = User.create!(
      cpf: '03987777052',
      email: 'rogerio@gmail.com',
      password: 'f4k3p455w0rd'
    )

    ######### Categories
    fine_art = CategoryItem.create!(
      description: "Arte Plástica"
    )

    musical_instrument = CategoryItem.create!(
      description: "Musical instrument"
    )

    ######### Lots for tests
    
    travel_to 2.days.ago do
      @lot_running = Lot.create!(
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
      auction_item.lot = @lot_running
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
      auction_item.lot = @lot_running
      auction_item.save!

      @lot_running.approver_user = approver
      @lot_running.approved!
      @lot_running.save!
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
      auction_item.lot = @lot_scheduled
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
      auction_item.lot = @lot_scheduled
      auction_item.save!

      @lot_scheduled.approver_user = approver
      @lot_scheduled.approved!
      @lot_scheduled.save!
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
      expect(page).to have_content 'Oferta mínima: R$ 100,00'
      expect(page).to have_field 'Oferta'
      expect(page).to have_button 'Fazer oferta'
    end
  end

  it 'se estiver autenticado' do
    visit lot_path(@lot_running)

    expect(page).not_to have_content 'Oferta mínima: R$ 100,00'
    expect(page).not_to have_field 'Oferta'
    expect(page).not_to have_button 'Fazer oferta'
  end

  it 'e não pode ser em um lote agendado' do
    login_as(@user)

    visit lot_path(@lot_scheduled)

    expect(page).not_to have_content 'Oferta mínima: R$ 100,00'
    expect(page).not_to have_field 'Oferta'
    expect(page).not_to have_button 'Fazer oferta'
  end

  it 'e não pode ser um adiministrador' do
    adm = User.create!(
      cpf: '35908375004',
      email: 'romero@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd'
    )

    login_as(adm)

    visit lot_path(@lot_running)

    expect(page).not_to have_content 'Oferta mínima: R$ 100,00'
    expect(page).not_to have_field 'Oferta'
    expect(page).not_to have_button 'Fazer oferta'
  end

  it 'com sucesso' do
    login_as(@user)

    visit lot_path(@lot_running)

    within '.bid-panel' do
      fill_in 'Oferta',	with: "101"
      click_on 'Fazer oferta'
    end

    expect(current_path).to eq lot_path(@lot_running)

    within '.bid-panel' do
      expect(page).not_to have_content 'Oferta mínima: R$ 103,00'
    end
  end

  it 'e envia valor errado' do
    login_as(@user)


    other_user = User.create!(
      cpf: '21519850085',
      email: 'david@uol.com',
      password: 'f4k3p455w0rd'
    )

    @lot_running.user_player_id = other_user
    @lot_running.offer = 101
    @lot_running.save!

    visit lot_path(@lot_running)

    within '.bid-panel' do
      fill_in 'Oferta',	with: "102"
      click_on 'Fazer oferta'
    end

    expect(page).to have_content 'Valor de oferta abaixo de mínimo!'
  end
end
