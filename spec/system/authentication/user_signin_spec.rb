require 'rails_helper'


describe 'Usuário faz login' do
  it 'a partir do menu' do
    user = User.create!(
      cpf: '76167052000',
      email: 'roberto@gmail.com',
      password: 'f4k3p455w0rd')

    visit root_path

    within 'header' do
      click_on 'Entrar'
    end

    within 'main form' do
      fill_in "Email",	with: "roberto@gmail.com"
      fill_in "Senha",	with: "f4k3p455w0rd"
      click_on 'Login'
    end


    expect(current_path).to eq root_path

    within 'header' do
      expect(page).not_to have_link 'Entrar'
    end
  end

  it 'como administrador' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@leilaodogalpao.com.br',
      password: 'f4k3p455w0rd')

    visit new_user_session_path

    within 'main form' do
      fill_in "Email",	with: "roberto@leilaodogalpao.com.br"
      fill_in "Senha",	with: "f4k3p455w0rd"
      click_on 'Login'
    end

    expect(page).to have_content '(adm)'
  end

  it 'como usuário comum' do
    user = User.create!(
      cpf: '83923678045',
      email: 'roberto@gmail.com',
      password: 'f4k3p455w0rd')

    visit new_user_session_path

    within 'main form' do
      fill_in "Email",	with: "roberto@gmail.com"
      fill_in "Senha",	with: "f4k3p455w0rd"
      click_on 'Login'
    end

    expect(page).not_to have_content '(adm)'
  end
end
