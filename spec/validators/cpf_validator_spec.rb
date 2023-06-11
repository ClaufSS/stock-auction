require 'rails_helper'


RSpec.describe CpfValidator do
  before do
    class CpfCase
      include ActiveModel::Model

      attr_accessor :cpf
      
      validates :cpf, cpf: true
    end
  end


  it 'valida um cpf válido' do
    cpf_case = CpfCase.new
    cpf_case.cpf = '80510449085'

    expect(cpf_case.valid?).to be true
  end

  it 'rejeita um cpf inválido' do
    cpf_case = CpfCase.new
    cpf_case.cpf = '80510449099'

    expect(cpf_case.valid?).to be false
    expect(cpf_case.errors[:cpf].empty?).to be false
  end

  it 'rejeita cpf de formato inválido' do
    cpf_case_first = CpfCase.new
    cpf_case_first.cpf = '8051044908'

    cpf_case_second = CpfCase.new
    cpf_case_second.cpf = 'abc10449085'


    expect(cpf_case_first.valid?).to be false
    expect(cpf_case_first.errors[:cpf].empty?).to be false
    expect(cpf_case_second.valid?).to be false
    expect(cpf_case_second.errors[:cpf].empty?).to be false
  end

  it 'rejeita casos especias de cpf válido' do
    cpf_case_first = CpfCase.new
    cpf_case_first.cpf = '12345678909'
    cpf_case_second = CpfCase.new
    cpf_case_second.cpf = '11111111111'

    expect(cpf_case_first.valid?).to be false
    expect(cpf_case_first.errors[:cpf].empty?).to be false
    expect(cpf_case_second.valid?).to be false
    expect(cpf_case_second.errors[:cpf].empty?).to be false
  end
end
