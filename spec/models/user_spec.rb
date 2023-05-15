require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'cpf deve ser fornecido' do
      user = User.new(
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd')
      
      user.valid?

      expect(user.errors[:cpf].empty?).to be false
    end

    it 'cpf deve conter 11 números' do
      user = User.new(
        cpf: '1234567890',
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd')

        user.valid?

        expect(user.errors[:cpf].empty?).to be false
    end

    it 'cpf deve conter apenas números' do
      user = User.new(
        cpf: 'abc70355038',
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd')

        user.valid?

        expect(user.errors[:cpf].empty?).to be false
    end

    it 'cpf deve ser válido' do
      user = User.new(
        cpf: '76167052001',
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd')

        user.valid?

        expect(user.valid?).to be false
    end

    it 'cpf deve ser único' do
      User.create!(
        cpf: '76167052000',
        email: 'roberto@gmail.com',
        password: 'f4k3p455w0rd')

      user = User.new(
        cpf: '76167052000',
        email: 'bertinho@gmail.com.br',
        password: 'f4k3p455w0rd')

      user.valid?

      expect(user.errors[:cpf]).to include 'já está em uso'
    end

    it 'email deve ser único' do
      User.create!(
        cpf: '76167052000',
        email: 'roberto@gmail.com',
        password: 'f4k3p455w0rd')

      user = User.new(
        cpf: '83923678045',
        email: 'roberto@gmail.com',
        password: 'f4k3p455w0rd')

      user.valid?

      expect(user.errors[:email]).to include 'já está em uso'
    end
  end

  describe 'registra como admin' do
    it 'só quando dominio é @leilaodogalpao.com.br' do
      user = User.create!(
        cpf: '76167052000',
        email: 'roberto@gmail.com',
        password: 'f4k3p455w0rd')

      expect(user.admin?).to be false
      expect(user.common?).to be true
    end

    it 'com sucesso' do
      user = User.create!(
        cpf: '83923678045',
        email: 'roberto@leilaodogalpao.com.br',
        password: 'f4k3p455w0rd')

      expect(user.admin?).to be true
    end
  end
end
