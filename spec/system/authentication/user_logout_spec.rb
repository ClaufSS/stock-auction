require 'rails_helper'


describe 'Usuário sai da conta' do
  it 'a partir do menu' do
    user = User.create!(
      cpf: '38974528045',
      email: 'roberto@gmail.com.br',
      password: 'f4k3p455w0rd')

    login_as(user)
    visit root_path

    within 'nav' do
      expect(page).to have_content 'Sair'
    end
  end

  it 'com sucesso' do
    user = User.create!(
      cpf: '38974528045',
      email: 'roberto@gmail.com.br',
      password: 'f4k3p455w0rd')

    login_as(user)
    visit root_path

    within 'nav' do
      click_on 'Sair'
    end
  end
end
