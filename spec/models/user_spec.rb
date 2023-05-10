require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'registra como admin' do
    it 'só quando dominio é @leilaodogalpao.com.br' do
      user = User.create!(email: 'roberto@gmail.com', password: 'f4k3p455w0rd')

      expect(user.admin?).to be false
      expect(user.common?).to be true
    end

    it 'com sucesso' do
      user = User.create!(email: 'roberto@leilaodogalpao.com.br', password: 'f4k3p455w0rd')

      expect(user.admin?).to be true
    end
  end
end
