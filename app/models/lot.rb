class Lot < ApplicationRecord
  belongs_to :register_user, class_name: 'User', foreign_key: :register_user_id
  belongs_to :approver_user, class_name: 'User', foreign_key: :approver_user_id, optional: true
  belongs_to :user_player, class_name: 'User', foreign_key: :user_player_id, optional: true
  has_many :auction_items

  validates :code, :start_date, :end_date, :start_price, :min_bid, presence: true
  validates :code, lot_code: true
  validates :start_date, comparison: {greater_than: :min_date_expected}, if: :not_persisted?
  validates :end_date, comparison: {greater_than: :start_date}, if: :not_persisted?

  after_validation :clear_items, if: :canceled?

  enum :status, {pending: 0, approved: 1, canceled: 2, closed: 3}

  scope :running, -> {
    where('status = ? AND ? BETWEEN start_date AND end_date', 1, Time.current)
  }

  scope :scheduled, -> {where('status = ? AND start_date > ?', 1, Time.current)}

  scope :expired, -> {where('status IN (?) AND end_date < ?', [0, 1], Time.current)}


  def running?
    Time.current.between? start_date, end_date
  end

  def scheduled?
    start_date > Time.current
  end

  def expired?
    end_date < Time.current
  end

  def min_offer
    return start_price unless user_player

    offer + min_bid
  end

  private

  def not_persisted?
    !persisted?
  end

  def min_date_expected
    1.day.from_now.to_date
  end

  def clear_items
    auction_items.clear
  end
end
