
FactoryGirl.define do

  factory :transaction do
    account
    category
    cents 100
    date { Date.today }
    description "Tim Hortons"
  end

end