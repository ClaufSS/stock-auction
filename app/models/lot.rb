class Lot < ApplicationRecord
  belongs_to :register_user, class_name: 'User', foreign_key: :register_user_id
  belongs_to :approver_user, class_name: 'User', foreign_key: :approver_user_id, optional: true

  validates :code, :start_date, :end_date, :start_price, :min_bid, presence: true
  validates :code, lot_code: true
  validates :start_date, :end_date, comparison: {greater_than: 1.day.from_now.to_date}
  validates :end_date, comparison: {greater_than: :start_date}
end