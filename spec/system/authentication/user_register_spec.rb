require 'rails_helper'


describe 'Usuário registra uma conta' do
  it 'a partir do menu' do
    visit root_path

    puts page

    within 'nav' do
      click_on 'Entrar'
    end
    
    click_on 'Inscrever-se'

    expect(current_path).to eq new_user_registration_path
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'Email'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'    
  end

  context 'com sucesso' do
    it 'como usuário comum' do
      visit root_path
      
      within 'nav' do
        click_on 'Entrar'
      end

      click_on 'Inscrever-se'

      within 'main form' do
        fill_in 'CPF',	with: '23639079060' 
        fill_in 'Email',	with: 'augusto@gmail.com' 
        fill_in 'Senha',	with: 'guto12345'
        fill_in 'Confirme sua senha',	with: 'guto12345'
        click_on 'Inscrever-se'
      end

      expect(current_path).to eq root_path

      within 'header' do
        expect(page).not_to have_content '(adm)'
      end
    end  

    it 'como administrador' do
      visit root_path

      within 'nav' do
        click_on 'Entrar'
      end

      click_on 'Inscrever-se'
  
      within 'main form' do
        fill_in 'CPF',	with: '23639079060' 
        fill_in 'Email',	with: 'augusto@leilaodogalpao.com.br' 
        fill_in 'Senha',	with: 'guto12345'
        fill_in 'Confirme sua senha',	with: 'guto12345'
        click_on 'Inscrever-se'
      end

      expect(current_path).to eq root_path
      
      within 'header' do
        expect(page).to have_content '(adm)'
      end
    end
  end
end
