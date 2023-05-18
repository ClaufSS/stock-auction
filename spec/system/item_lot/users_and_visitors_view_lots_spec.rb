require 'rails_helper'


describe 'Usuários e visitantes vêem lotes' do
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
      @lot_closed = Lot.create!(
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
      auction_item.lot = @lot_closed
      auction_item.save!
      
      auction_item = AuctionItem.new(
        name: "Notebook",
        description: "Notebook de alta performance com processador Intel Core i7",
        weight: "1800",
        width: "35",
        height: "25",
        depth: "2",
        category_item: eletronic
      )
      
      attach_img.call(auction_item, "generic-laptop-mrkwx98-600.jpg")
      auction_item.lot = @lot_closed
      auction_item.save!

      @lot_closed.save!
    end

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


  it 'com sucesso' do
    visit root_path

    expect(page).to have_link "#{@lot_running.code}"
  end

  it 'separados por, em andamento e futuros' do
    visit root_path

    lots_running_node = page
      .find('section/div', text: 'Lotes em disputa')
    
    lots_scheduled_node = page
      .find('section/div', text: 'Lotes agendados')
    

    within lots_running_node do
      expect(page).to have_link "#{@lot_running.code}"
      expect(page).not_to have_link "#{@lot_scheduled.code}"
    end

    within lots_scheduled_node do
      expect(page).to have_link "#{@lot_scheduled.code}"
      expect(page).not_to have_link "#{@lot_running.code}"
    end
  end

  it 'e não deve mostrar lotes expirados' do
    visit root_path

    expect(page).not_to have_link "#{@lot_closed.code}"
  end
end
