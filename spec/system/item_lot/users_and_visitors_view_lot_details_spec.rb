require 'rails_helper'


describe 'Usuário vê detalhes de um lote' do
  include ActiveSupport::Testing::TimeHelpers
  include ActionView::Helpers::NumberHelper


  it 'com sucesso' do
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
    fine_art = CategoryItem.create!(
      description: "Arte Plástica"
    )


    ######### Lots for tests
    travel_to 2.days.ago.to_time do
      @lot = Lot.create!(
        code: '000art',
        start_date: 1.day.from_now,
        end_date: 4.days.from_now,
        start_price: 100,
        min_bid: 2,
        register_user: creator
      )
    end

    ######### Arts
    first_item = AuctionItem.new(
      name: "Escultura de Bronze",
      description: "Escultura detalhada em bronze, representando uma figura humana",
      weight: "2500",
      width: "30",
      height: "60",
      depth: "20",
      category_item: fine_art
    )
    
    attach_img.call(first_item, "3d3c94df-e78a-42d8-b0f5-5f0a32bb2945-szoxut.jpg")
    first_item.lot = @lot
    first_item.save!

    second_item = AuctionItem.new(
      name: "Escultura em Madeira",
      description: "Escultura única em madeira maciça, esculpida à mão",
      weight: "5000",
      width: "40",
      height: "60",
      depth: "30",
      category_item: fine_art
    )
    
    attach_img.call(second_item, "banco-ave-741feitoamao_mg_8.jpg")
    second_item.lot = @lot
    second_item.save

    @lot.approver_user = approver
    @lot.approved!
    @lot.save!

    visit root_path

    click_on "#{@lot.code}"


    expect(page).to have_content "Lote 000art"
    expect(page).to have_content I18n.l(@lot.start_date, format: :long)
    expect(page).to have_content I18n.l(@lot.end_date, format: :long)
    expect(page).to have_content number_to_currency(@lot.start_price)
    expect(page).to have_content number_to_currency(@lot.min_bid)
    expect(page).to have_content 'roberto@leilaodogalpao.com.br'
    expect(page).to have_content 'reidoleilao@leilaodogalpao.com.br'

    puts first_item.lot

    within 'details' do
      page.click
      
      expect(page).to have_content "Escultura de Bronze - #{first_item.code}"
      expect(page).to have_content "Escultura em Madeira - #{second_item.code}"
      expect(page).not_to have_button 'Remover'  
    end
  end
end
