
FactoryGirl.define do

  factory :account do
    name "MyAccount"
  end

  factory :debt_account, parent: :account do
    debt true
  end

end