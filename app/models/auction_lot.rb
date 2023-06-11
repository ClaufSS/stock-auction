class AuctionLot < ApplicationRecord
  belongs_to :creator_user, class_name: 'User', foreign_key: :creator_user_id
  belongs_to :evaluator_user, class_name: 'User', foreign_key: :evaluator_user_id, optional: true
  belongs_to :winner_bidder, class_name: 'User', foreign_key: :winner_bidder_id, optional: true
  has_many :auction_items
  has_many :bids, class_name: "AuctionBid"

  validates :code, lot_code: true
  validates :code, :start_date, :end_date, :start_price, :min_bid_diff, presence: true
  validates :start_date, comparison: {greater_than: :min_date_expected}, if: :start_date_changed?
  validates :end_date, comparison: {greater_than: :start_date}, if: :end_date_changed?

  after_validation :clear_items, if: :canceled?
  before_validation :check_evaluator, on: :update, unless: :pending?

  enum :status, {pending: 0, approved: 1, canceled: 2, closed: 3}

  scope :running, -> {
    where('status = ? AND ? BETWEEN start_date AND end_date', 1, Time.current)}

  scope :scheduled, -> { where('status = ? AND start_date > ?', 1, Time.current) }
  scope :expired, -> { where('status IN (?) AND end_date < ?', [0, 1], Time.current) }


  def running?
    approved? && Time.current.between?(start_date, end_date)
  end

  def scheduled?
    approved? && (start_date > Time.current)
  end

  def expired?
    (pending? || approved?) && (end_date < Time.current)
  end

  def min_bid
    last_bid = bids.maximum(:bid)
    
    last_bid ? last_bid + min_bid_diff : start_price
  end

  
  private

  def min_date_expected
    1.day.from_now.to_date
  end

  def check_evaluator
    return errors.add(:base, 'É necessário fornecer o responsável pela avaliação.') unless evaluator_user
  
    errors.add(:base, 'Usuário avaliador não pode ser o criador do lote!') if creator_user === evaluator_user
    errors.add(:base, 'Avaliador precisa ser um administrador!') unless evaluator_user.admin?
  end

  def clear_items
    auction_items.clear
  end
end
