require 'rails_helper'


describe 'Administrador cria um lote' do
  context 'e adiciona itens' do
    it 'apenas enquando aguarda aprovação' do
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

      login_as(user)
      lot.running!
      visit lot_path(lot)

      expect(page).not_to have_content 'Adicionar itens'
      expect(page).to have_no_selector '.add-item-area'
      expect(page).not_to have_button 'Adicionar'
    end

    it 'com sucesso' do
      user = User.create!(
        cpf: '83923678045',
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd')


      musical_instrument = CategoryItem.create!(
        description: "Musical instrument"
      )
      
      eletronic = CategoryItem.create!(
        description: "Eletrônico"
      )
      
      office = CategoryItem.create!(
        description: "Escritório"
      )
        

      attach_img = ->(item, filename) {
        item.photo.attach(
          io: File.open(Rails.root.join("public/photo_items/#{filename}")),
          filename: filename,
          content_type: 'image/png'
        )
      }    
      
      cellphone = AuctionItem.new(
        name: "Smartphone",
        description: "Smartphone de última geração com câmera de alta resolução",
        weight: "180",
        width: "7",
        height: "14",
        depth: "0.8",
        category_item: eletronic
      )
      
      attach_img.call(cellphone, "samsung-galaxy-a54-5g.jpg")
      cellphone.save!
      
      office_table = AuctionItem.new(
        name: "Mesa de Escritório",
        description: "Mesa de escritório em madeira com gavetas embutidas",
        weight: "5000",
        width: "120",
        height: "75",
        depth: "60",
        category_item: office
      )

      attach_img.call(office_table, "eb48a2995fab59fdd9501c21632a9218.jpg")
      office_table.save!
      
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

      login_as(user)
      visit lot_path(lot)

      within '.add-item-area' do
        within 'select' do
          select "Guitarra Elétrica - #{guitar.code}"
        end

        click_on 'Adicionar'
      end

      expect(current_path).to eq lot_path(lot)
      
      within 'details' do
        page.click
        expect(page).to have_content "Guitarra Elétrica - #{guitar.code}"
        expect(page).to have_button "Remover"
      end

      within '.add-item-area' do
        expect(page).not_to have_select with_options: ["Guitarra Elétrica - #{guitar.code}"]
      end
    end
  end
end
