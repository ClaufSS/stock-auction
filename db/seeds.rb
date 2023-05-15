# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


####################################################
# Usuários

User.create!(
  cpf: "54690229007",
  email: "juliao@gmail.com",
  password: "f4k3p455w0rd"
)

User.create!(
  cpf: "33415051056",
  email: "marcossts@gmail.com",
  password: "f4k3p455w0rd"
)

User.create!(
  cpf: "43380443069",
  email: "silvanei@gmail.com",
  password: "f4k3p455w0rd"
)

User.create!(
  cpf: "96113990060",
  email: "antonioleiloeiro@leilaodogalpao.com.br",
  password: "f4k3p455w0rd"
)

User.create!(
  cpf: "14392097072",
  email: "victor@leilaodogalpao.com.br",
  password: "f4k3p455w0rd"
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

attach_img.call(auction_item, "-CG-162-C-1.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Smartphone",
  description: "Smartphone de última geração com câmera de alta resolução",
  weight: "180",
  width: "7",
  height: "14",
  depth: "0.8",
  category_item: eletronic
)

attach_img.call(auction_item, "samsung-galaxy-a54-5g.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Mesa de Escritório",
  description: "Mesa de escritório em madeira com gavetas embutidas",
  weight: "5000",
  width: "120",
  height: "75",
  depth: "60",
  category_item: office
)

attach_img.call(auction_item, "eb48a2995fab59fdd9501c21632a9218.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Vaso Decorativo",
  description: "Vaso de cerâmica pintado à mão",
  weight: "700",
  width: "20",
  height: "30",
  depth: "20",
  category_item: decoration
)

attach_img.call(auction_item, "vaso-decorativo-flat-italy-lyor-vidro.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Tapete Automotivo",
  description: "Tapete resistente para uso em veículos",
  weight: "2000",
  width: "70",
  height: "50",
  depth: "2",
  category_item: automotive
)

attach_img.call(auction_item, "tapete-automotivo-universal-preto-e6087-4-pecas-ecotap.jpg")
auction_item.save

auction_item = AuctionItem.new(
  name: "Pintura Abstrata",
  description: "Obra de arte abstrata em tela, com cores vibrantes",
  weight: "300",
  width: "50",
  height: "70",
  depth: "4",
  category_item: fine_art
)

attach_img.call(auction_item, "2492339-pintura-retrato-gato-abstrato-vetor.jpg")
auction_item.save

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
auction_item.save

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
auction_item.save

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
auction_item.save

auction_item = AuctionItem.new(
  name: "Luminária de Mesa",
  description: "Luminária elegante de mesa, com base de madeira e cúpula de vidro",
  weight: "1200",
  width: "25",
  height: "40",
  depth: "25",
  category_item: decoration
)

attach_img.call(auction_item, "435223z.jpg")
auction_item.save

####################################################
# Lotes de item

####################################################
# 

####################################################
# 
