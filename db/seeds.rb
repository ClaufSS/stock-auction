
####################################################
# Usuários

User.create!(
  cpf: "54690229007",
  email: "juliao@gmail.com",
  password: "12345678"
)

User.create!(
  cpf: "33415051056",
  email: "marcos@gmail.com",
  password: "12345678"
)

User.create!(
  cpf: "43380443069",
  email: "silvaneide@gmail.com",
  password: "12345678"
)

User.create!(
  cpf: "39525559084",
  email: "silvanei@gmail.com",
  password: "12345678"
)

User.create!(
  cpf: "49191314020",
  email: "carlos@gmail.com",
  password: "12345678"
)

User.create!(
  cpf: "96113990060",
  email: "jose@leilaodogalpao.com.br",
  password: "12345678"
)

User.create!(
  cpf: "14392097072",
  email: "victor@leilaodogalpao.com.br",
  password: "12345678"
)

####################################################
# Categorias de item
musical_instrument = CategoryItem.create!(
  description: "Musical instrument"
)

eletronic = CategoryItem.create!(
  description: "Eletrônico"
)

office = CategoryItem.create!(
  description: "Escritório"
)

decoration = CategoryItem.create!(
  description: "Decoração"
)

automotive = CategoryItem.create!(
  description: "Automotivo"
)

fine_art = CategoryItem.create!(
  description: "Arte Plástica"
)

####################################################
# Itens de leilão

attach_img = ->(item, filename) {
  item.photo.attach(
    io: File.open(Rails.root.join("public/photo_items/#{filename}")),
    filename: filename,
    content_type: 'image/png'
  )
}


auction_item = AuctionItem.new(
  name: "Violão Acústico",
  description: "Violão de cordas de aço, perfeito para músicos iniciantes",
  weight: "1500",
  width: "100",
  height: "10",
  depth: "40",
  category_item: musical_instrument
)

sleep(0.25)

attach_img.call(auction_item, "-CG-162-C-1.jpg")
auction_item.save!

auction_item = AuctionItem.new(
  name: "Smartphone",
  description: "Smartphone de última geração com câmera de alta resolução",
  weight: "180",
  width: "7",
  height: "14",
  depth: "0.8",
  category_item: eletronic
)

sleep(0.25)

attach_img.call(auction_item, "samsung-galaxy-a54-5g.jpg")
auction_item.save!

auction_item = AuctionItem.new(
  name: "Mesa de Escritório",
  description: "Mesa de escritório em madeira com gavetas embutidas",
  weight: "5000",
  width: "120",
  height: "75",
  depth: "60",
  category_item: office
)

sleep(0.25)

attach_img.call(auction_item, "eb48a2995fab59fdd9501c21632a9218.jpg")
auction_item.save!

auction_item = AuctionItem.new(
  name: "Vaso Decorativo",
  description: "Vaso de cerâmica pintado à mão",
  weight: "700",
  width: "20",
  height: "30",
  depth: "20",
  category_item: decoration
)

sleep(0.25)

attach_img.call(auction_item, "vaso-decorativo-flat-italy-lyor-vidro.jpg")
auction_item.save!

auction_item = AuctionItem.new(
  name: "Tapete Automotivo",
  description: "Tapete resistente para uso em veículos",
  weight: "2000",
  width: "70",
  height: "50",
  depth: "2",
  category_item: automotive
)

sleep(0.25)

attach_img.call(auction_item, "tapete-automotivo-universal-preto-e6087-4-pecas-ecotap.jpg")
auction_item.save!

auction_item = AuctionItem.new(
  name: "Pintura Abstrata",
  description: "Obra de arte abstrata em tela, com cores vibrantes",
  weight: "300",
  width: "50",
  height: "70",
  depth: "4",
  category_item: fine_art
)

sleep(0.25)

attach_img.call(auction_item, "2492339-pintura-retrato-gato-abstrato-vetor.jpg")
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

sleep(0.25)

attach_img.call(auction_item, "7899871608841-1.jpg")
auction_item.save!

auction_item = AuctionItem.new(
  name: "Câmera Fotográfica",
  description: "Câmera profissional com lente intercambiável e recursos avançados",
  weight: "800",
  width: "15",
  height: "10",
  depth: "8",
  category_item: eletronic
)

sleep(0.25)

attach_img.call(auction_item, "e2905b38d6ec704f88a29ebfbc066862.jpeg")
auction_item.save!

auction_item = AuctionItem.new(
  name: "Escultura de Bronze",
  description: "Escultura detalhada em bronze, representando uma figura humana",
  weight: "2500",
  width: "30",
  height: "60",
  depth: "20",
  category_item: fine_art
)

sleep(0.25)

attach_img.call(auction_item, "3d3c94df-e78a-42d8-b0f5-5f0a32bb2945-szoxut.jpg")
auction_item.save!

auction_item = AuctionItem.new(
  name: "Luminária de Mesa",
  description: "Luminária elegante de mesa, com base de madeira e cúpula de vidro",
  weight: "1200",
  width: "25",
  height: "40",
  depth: "25",
  category_item: decoration
)

sleep(0.25)

attach_img.call(auction_item, "435223z.jpg")
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

sleep(0.25)

attach_img.call(auction_item, "generic-laptop-mrkwx98-600.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Escultura em Madeira",
  description: "Escultura única em madeira maciça, esculpida à mão",
  weight: "5000",
  width: "40",
  height: "60",
  depth: "30",
  category_item: fine_art
)

sleep(0.25)

attach_img.call(auction_item, "banco-ave-741feitoamao_mg_8.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Mesa de Centro",
  description: "Mesa de centro moderna em vidro temperado",
  weight: "1500",
  width: "80",
  height: "40",
  depth: "80",
  category_item: decoration
)

sleep(0.25)

attach_img.call(auction_item, "1xg.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Teclado MIDI",
  description: "Teclado controlador MIDI com pads e knobs para produção musical",
  weight: "2500",
  width: "90",
  height: "15",
  depth: "25",
  category_item: musical_instrument
)

sleep(0.25)

attach_img.call(auction_item, "699cc265d4.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Pintura a Óleo",
  description: "Pintura clássica a óleo, retratando uma paisagem montanhosa",
  weight: "3000",
  width: "80",
  height: "60",
  depth: "5",
  category_item: fine_art
)

sleep(0.25)

attach_img.call(auction_item, "pintura-a-oleo-quadro-8-ensaio-sobre-atena-original.jpg")
auction_item.save

####################################################
# Lotes de item

admin_antonio = User.find_by(cpf: "96113990060", user_type: :admin)
admin_victor = User.find_by(cpf: "14392097072", user_type: :admin)


arts = AuctionItem.where(category_item: fine_art)

lot_one = AuctionLot.new(
  code: 'D2E9H4',
  start_date: 0.day.from_now,
  end_date: 1.week.from_now,
  start_price: 800,
  min_bid_diff: 95,
  creator_user: admin_antonio,
  evaluator_user: admin_victor,
  status: :approved
)

lot_one.auction_items << arts
lot_one.save(validate: false)


eletronics = AuctionItem.where(category_item: eletronic)

lot_two = AuctionLot.new(
  code: 'Y7G5P1',
  start_date: 0.day.from_now,
  end_date: 0.day.from_now + 8.minutes,
  start_price: 260,
  min_bid_diff: 25,
  creator_user: admin_antonio,
  evaluator_user: admin_victor,
  status: :approved
)

lot_two.auction_items << eletronics
lot_two.save(validate: false)


decorations = AuctionItem.where(category_item: decoration)

lot_three = AuctionLot.new(
  code: 'N3V6K2',
  start_date: 2.days.from_now,
  end_date: 1.week.from_now + 2.days,
  start_price: 200,
  min_bid_diff: 18,
  creator_user: admin_victor,
  evaluator_user: admin_antonio,
  status: :approved
)

lot_three.auction_items << decorations
lot_three.save(validate: false)


musical_instruments = AuctionItem.where(category_item: musical_instrument)

lot_four = AuctionLot.new(
  code: 'R9M5X8',
  start_date: 4.days.ago,
  end_date: 1.day.ago,
  start_price: 100,
  min_bid_diff: 5,
  creator_user: admin_victor,
  evaluator_user: admin_antonio
)

lot_four.auction_items << musical_instruments.first
lot_four.save(validate: false)
