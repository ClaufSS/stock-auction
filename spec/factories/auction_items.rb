FactoryBot.define do
  factory :auction_item do
    after(:build) do |auction_item|
      auction_item.attach(
        io: File.open('path/to/avatar.jpg'),
        filename: 'avatar.jpg', content_type: 'image/jpeg'
      )
    end
  end
end
