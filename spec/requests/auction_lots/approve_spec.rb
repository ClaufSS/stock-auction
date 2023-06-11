require 'rails_helper'

RSpec.describe "AuctionLots", type: :request do
  describe "POST /auction_lots/:id/approve" do
    it 'Administrador não pode aprovar um lote seu' do
      user = User.create!(
        cpf: '83923678045',
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )
    
      musical_instrument = CategoryItem.create!(
        description: "Musical instrument"
      )
        

      attach_img = ->(item, filename) {
        item.photo.attach(
          io: File.open(Rails.root.join("public/photo_items/#{filename}")),
          filename: filename,
          content_type: 'image/png'
        )
      }

      guitar = AuctionItem.new(
        name: "Guitarra Elétrica",
        description: "Guitarra elétrica de alta qualidade, perfeita para performances ao vivo",
        weight: "3500",
        width: "40",
        height: "100",
        depth: "10",
        category_item: musical_instrument
      )

      attach_img.call(guitar, "7899871608841-1.jpg")
      guitar.save!


      lot = AuctionLot.create!(
        code: 'abc123',
        start_date: 2.days.from_now,
        end_date: 1.week.from_now,
        start_price: 100,
        min_bid_diff: 2,
        creator_user: user
      )

      lot.auction_items << guitar

      login_as(user)

      post approve_auction_lot_path(lot)
      
      follow_redirect!

      expect(request.path).to eq root_path
      expect(response.body).to include 'Ação não permitida!'
    end
  end
end
