class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :auction_lots, class_name: "AuctionLot", foreign_key: :winner_bidder_id

  
  validates :cpf, presence: true
  validates :cpf, :email, uniqueness: true
  validates :cpf, cpf: true

  enum :user_type, {admin: 0, common: 1}

  before_validation :set_user_type, on: :create

  private

  def set_user_type
    admin_domain = '@leilaodogalpao.com.br'
    
    self.user_type = :admin if email.ends_with?(admin_domain)
  end
end
