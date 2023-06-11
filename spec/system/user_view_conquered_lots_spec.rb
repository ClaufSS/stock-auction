require 'rails_helper'


describe 'Usuário vê lotes conquistados' do
  it 'com sucesso' do
    attach_img = ->(item, filename) {
      item.photo.attach(
        io: File.open(Rails.root.join("public/photo_items/#{filename}")),
        filename: filename,
        content_type: 'image/png'
      )
    }

    ######## User
    user = User.create!(
      cpf: "54690229007",
      email: "juliao@gmail.com",
      password: "juliao<3Leilao"
    )
    
    ######### Admins
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

    musical_instrument = CategoryItem.create!(
      description: "Musical instrument"
    )

    ######### AuctionLots for tests
    travel_to 1.week.ago do
      AuctionLot.create!(
        code: 'MUS248',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid_diff: 2,
        creator_user: creator
      )
    end

    travel_to 1.week.ago do
      AuctionLot.create!(
        code: 'eLe110',
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        start_price: 100,
        min_bid_diff: 2,
        creator_user: creator
      )
    end

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
    
    first_lot = AuctionLot.find_by(code: 'MUS248')
    attach_img.call(auction_item, "-CG-162-C-1.jpg")
    auction_item.auction_lot = first_lot
    auction_item.save!
    first_lot.evaluator_user = approver
    first_lot.bids.create!(bidder: user, bid: 150)
    first_lot.winner_bidder = user
    first_lot.closed!


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
    
    second_lot = AuctionLot.find_by(code: 'eLe110')
    attach_img.call(auction_item, "e2905b38d6ec704f88a29ebfbc066862.jpeg")
    auction_item.auction_lot = second_lot
    auction_item.save!
    second_lot.evaluator_user = approver
    second_lot.bids.create!(bidder: user, bid: 150)
    second_lot.winner_bidder = user
    second_lot.closed!

    login_as(user)

    visit conquered_auction_lots_path

    expect(page).to have_link "#{first_lot.code}"
    expect(page).to have_link "#{second_lot.code}"
  end
end
