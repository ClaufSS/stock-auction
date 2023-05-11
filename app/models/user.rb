class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  validates :cpf, presence: true
  validates :cpf, :email, uniqueness: true
  validates :cpf, cpf: true

  enum :user_type, {admin: 0, common: 1}

  scope :admins, -> { where(user_type: :admin)}

  before_validation :set_user_type, on: :create

  private

  def set_user_type
    adm_domain = '@leilaodogalpao.com.br'
    
    self.user_type = self.email.ends_with?(adm_domain) ? :admin : :common
  end
end
