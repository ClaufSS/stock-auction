require 'rails_helper'

describe 'Administrador registra um lote' do
  it 'a partir do menu' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

    login_as(user)
    visit root_path

    within 'nav' do
      click_on 'Novo lote'
    end

    expect(page).to have_field 'Código'
    expect(page).to have_field 'Data de início'
    expect(page).to have_field 'Data de encerramento'
    expect(page).to have_field 'Preço inicial'
    expect(page).to have_field 'Lance mínimo'
  end

  it 'com sucesso' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

    one_day_later = 1.day.from_now
    two_day_later = 2.day.from_now

    login_as(user)
    visit new_auction_lot_path

    within 'main form' do
      fill_in 'Código', with: 'abc123'
      fill_in 'Data de início', with: one_day_later
      fill_in 'Data de encerramento', with: two_day_later
      fill_in 'Preço inicial', with: '100'
      fill_in 'Lance mínimo', with: '2'

      click_on 'Registrar'
    end

    expect(page).to have_content 'Lote registrado com sucesso!'
    expect(page).to have_content 'Lote abc123'
    expect(page).to have_content 'roberto@leilaodogalpao.com.br'
    expect(page).to have_content I18n.l(one_day_later, format: :long)
    expect(page).to have_content I18n.l(two_day_later, format: :long)
    expect(page).to have_content 'R$ 100,00'
    expect(page).to have_content 'R$ 2,00'
  end
end


describe 'Deve ser proibido' do
  context 'ver link Novo lote' do
    it 'para usuários comum' do
      user = User.create!(
        cpf: '83923678045',
        email: 'sergiolimag@uol.com',
        password: 'f4k3p455w0rd')
  
      login_as(user)
      visit root_path

      expect(page).not_to have_link 'Novo lote'
    end

    it 'para visitantes' do
      visit root_path

      expect(page).not_to have_link 'Novo lote'
    end
  end

  context 'ter acesso a registro de lote' do
    it 'para usuários comum' do
      user = User.create!(
        cpf: '83923678045',
        email: 'sergiolimag@uol.com',
        password: 'f4k3p455w0rd')
  
      login_as(user)
      visit new_auction_lot_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Acesso restrito apenas para administradores.'
    end

    it 'para visitantes' do
      visit new_auction_lot_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end
  end
end
