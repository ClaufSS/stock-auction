require 'rails_helper'


describe 'Página destinada a verificação de lotes conquistados' do
  
  context 'caso seja administrador' do
    it 'não deve ver link' do
      admin = User.create!(
        cpf: '83349076050',
        email: 'reidoleilao@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )

      login_as(admin)

      visit root_path

      expect(page).not_to have_link 'Meus Lotes'
    end

    it 'deve ter acesso proibido a rota' do
      admin = User.create!(
        cpf: '83349076050',
        email: 'reidoleilao@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd'
      )

      login_as(admin)

      visit conquered_auction_lots_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Ação não permitida!'
    end
  end

  it 'para acessar deve estar autenticado' do
    visit root_path

    expect(page).not_to have_link 'Meus Lotes'
  end

  it 'deve ter acesso a partir do menu' do
    user = User.create!(
      cpf: "54690229007",
      email: "juliao@gmail.com",
      password: "juliao<3Leilao"
    )

    login_as(user)
    visit root_path
    
    within 'header nav' do
      click_on 'Meus lotes'
    end

    expect(current_path).to eq conquered_auction_lots_path
    expect(page).to have_content 'Lotes conquistados'
  end

  context 'não deve conter' do
    it 'lotes cancelados' do
      user = User.create!(
        cpf: "54690229007",
        email: "juliao@gmail.com",
        password: "juliao<3Leilao"
      )

      creator = FactoryBot.create(:creator)
      evaluator = FactoryBot.create(:evaluator)

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

      lot = AuctionLot.find_by(code: 'MUS248')
      lot.evaluator_user = evaluator
      lot.canceled!

      login_as(user)
      visit conquered_auction_lots_path

      expect(page).not_to have_link "#{lot.code}"
    end

    it 'lotes agendados' do
      user = User.create!(
        cpf: "54690229007",
        email: "juliao@gmail.com",
        password: "juliao<3Leilao"
      )

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

      lot = AuctionLot.create!(
        code: 'MUS248',
        start_date: 1.week.from_now,
        end_date: 2.weeks.from_now,
        start_price: 208,
        min_bid_diff: 7,
        creator_user: creator,
        evaluator_user: approver
      )

      lot.approved!

      login_as(user)
      visit conquered_auction_lots_path

      expect(page).not_to have_link "#{lot.code}"
    end

    it 'lotes em disputa' do
      user = User.create!(
        cpf: "54690229007",
        email: "juliao@gmail.com",
        password: "juliao<3Leilao"
      )

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

      travel_to 2.days.ago do
        lot = AuctionLot.create!(
          code: 'MUS248',
          start_date: 1.day.from_now,
          end_date: 6.days.from_now,
          start_price: 80,
          min_bid_diff: 1.5,
          creator_user: creator,
          evaluator_user: approver
        )

        lot.approved!
      end

      lot = AuctionLot.find_by(code: 'MUS248')

      login_as(user)
      visit conquered_auction_lots_path

      expect(page).not_to have_link "#{lot.code}"
    end

    it 'lotes conquistados por outros usuários' do
      user = User.create!(
        cpf: "54690229007",
        email: "juliao@gmail.com",
        password: "juliao<3Leilao"
      )

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

      other_user = User.create!(
        cpf: "43380443069",
        email: "silvanei@gmail.com",
        password: "Silvan31"
      )

      travel_to 1.week.ago do
        lot = AuctionLot.create!(
          code: 'MUS248',
          start_date: 1.day.from_now,
          end_date: 3.days.from_now,
          start_price: 100,
          min_bid_diff: 2,
          creator_user: creator,
          evaluator_user: approver,
          winner_bidder: other_user,
          status: :approved
        )

        lot.bids.create!(bidder: other_user, bid: 101)
        lot.save!
      end
      
      lot = AuctionLot.find_by(code: 'MUS248')

      login_as(user)
      visit conquered_auction_lots_path

      expect(page).not_to have_link "#{lot.code}"
    end
  end
end
