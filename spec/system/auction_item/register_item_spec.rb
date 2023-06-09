require 'rails_helper'


describe 'Administrador registra pedido' do
  it 'a partir do menu' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

    login_as(user)
    visit root_path

    within 'nav' do
      click_on 'Novo item'
    end

    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Foto'
    expect(page).to have_field 'Largura'
    expect(page).to have_field 'Altura'
    expect(page).to have_field 'Profundidade'
    expect(page).to have_field 'Categoria'
    expect(page).to have_button 'Registrar'
  end

  it 'com sucesso' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

    CategoryItem.create!(description: 'Instrumento musical')
    CategoryItem.create!(description: 'Peças automotivas')

    file_path = Rails.root.join('spec/support/images/sample.png')

    login_as(user)
    visit root_path

    within 'nav' do
      click_on 'Novo item'
    end

    within 'main form' do
      fill_in 'Nome', with: 'Violão Customizado'
      fill_in 'Descrição', with: 'Um violão acústico único feito à mão com materiais de alta qualidade.'
      fill_in 'Peso', with: '2000'
      fill_in 'Largura', with: '45'
      fill_in 'Altura', with: '100'
      fill_in 'Profundidade', with: '10'
      select 'Instrumento musical', from: 'Categoria'

      page.attach_file('Foto', file_path)
    end

    click_on 'Registrar'

    expect(page).to have_content 'Violão Customizado'
    expect(page).to have_content 'Um violão acústico único feito à mão com materiais de alta qualidade.'
    expect(page).to have_content 'Dimensão (cm): 45 X 100 X 10'
    expect(page).to have_content 'Peso (g): 2000'
  end

  it 'com iformações incorretas' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

    CategoryItem.create!(description: 'Instrumento musical')

    login_as(user)
    visit root_path

    within 'nav' do
      click_on 'Novo item'
    end

    within 'main form' do
      fill_in 'Nome', with: 'Violão Customizado'
      fill_in 'Largura', with: '45'
      fill_in 'Profundidade', with: '10'
    end

    click_on 'Registrar'

    expect(page).to have_content 'Alguns campos estão incorretos, revise-os.'
  end
end

describe 'Deve ser proibido' do
  context 'ver link Novo item' do
    it 'para usuários comum' do
      user = User.create!(
        cpf: '38974528045',
        email: 'carlos@uol.com',
        password: 'f4k3p455w0rd')

      login_as(user)
      visit root_path

      within 'nav' do
        expect(page).not_to have_link 'Novo item'
      end
    end

    it 'para visitantes' do
      visit root_path

      within 'nav' do
        expect(page).not_to have_link 'Novo item'
      end
    end
  end

  context 'ter acesso a página de registro de item' do
    it 'para usuários comum' do
      user = User.create!(
        cpf: '38974528045',
        email: 'carlos@uol.com.br',
        password: 'f4k3p455w0rd')

      login_as(user)
      visit new_auction_item_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Acesso restrito apenas para administradores.'
    end

    it 'para visitantes' do
      visit new_auction_item_path
    
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end
  end
end
