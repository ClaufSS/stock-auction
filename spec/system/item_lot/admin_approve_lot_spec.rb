require 'rails_helper'


describe 'Administrador aprova lote' do
  it 'que outro administrador criou' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

    charles = User.create!(
      cpf: '99760017032',
      email: 'charles@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

  
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
    
    acoustic_guitar = AuctionItem.new(
      name: "Violão Acústico",
      description: "Violão de cordas de aço, perfeito para músicos iniciantes",
      weight: "1500",
      width: "100",
      height: "10",
      depth: "40",
      category_item: musical_instrument
    )
    
    attach_img.call(acoustic_guitar, "-CG-162-C-1.jpg")
    acoustic_guitar.save!
    
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


    lot = Lot.create!(
      code: 'abc123',
      start_date: 1.day.from_now,
      end_date: 2.day.from_now,
      start_price: 100,
      min_bid: 2,
      register_user: user
    )

    lot.auction_items << acoustic_guitar
    lot.auction_items << guitar

    login_as(charles)
    visit lot_path(lot)

    click_on 'Aprovar Lote'

    expect(page).to have_content 'Lote aprovado com sucesso!'
    expect(current_path).to eq lot_path(lot)
    expect(page).not_to have_button 'Aprovar Lote'
    expect(page).to have_content 'Status: Em disputa'
  end

  it 'não deve poder aprovar um lote seu' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')
  
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


    lot = Lot.create!(
      code: 'abc123',
      start_date: 1.day.from_now,
      end_date: 2.day.from_now,
      start_price: 100,
      min_bid: 2,
      register_user: user
    )

    lot.auction_items << guitar

    login_as(user)
    visit lot_path(lot)

    expect(page).not_to have_button 'Aprovar Lote'
  end
end
