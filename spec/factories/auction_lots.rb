FactoryBot.define do
  factory :auction_lot do
    sequence(:code) { |n| "LOT#{ sprintf("%03d", n) }" }
    start_date { 1.day.from_now }
    end_date { 3.week.from_now }
    start_price { 100 }
    min_bid_diff { 2 }
    creator_user { FactoryBot.create(:admin_user) }
  end
end
