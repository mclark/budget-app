
FactoryGirl.define do

  factory :category do
    parent_id { Category.expense.id }
    name "Restaurant"
  end

  factory :expense_category, parent: :category do
  end

  factory :income_category, parent: :category do
    parent_id { Category.income.id }
  end

end