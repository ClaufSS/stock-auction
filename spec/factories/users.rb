FactoryBot.define do
  factory :admin_user, class: 'User' do
    cpf { '55943685073' }
    email { 'john@leilaodogalpao.com.br' }
    password { 'f4k3p455w0rd' }
  end

  factory :common_user, class: 'User' do
    cpf { '00416941044' }
    email { 'jane@mail.com' }
    password { 'f4k3p455w0rd' }
  end

  factory :creator, class: 'User' do
    cpf { '29940402040' }
    email { 'megan@leilaodogalpao.com.br' }
    password { 'f4k3p455w0rd' }
  end

  factory :evaluator, class: 'User' do
    cpf { '32678025047' }
    email { 'alfredo@leilaodogalpao.com.br' }
    password { 'f4k3p455w0rd' }
  end
end
