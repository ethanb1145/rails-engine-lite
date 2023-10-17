FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { Faker::Lorem.word }
  end
end