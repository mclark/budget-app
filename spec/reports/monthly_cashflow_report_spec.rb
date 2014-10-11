require 'rails_helper'

describe MonthlyCashflowReport do
  subject { described_class.new }

  let!(:work) { create(:income_category, name: "Work") }
  let!(:bonus) { create(:income_category, name: "Bonus") }
  let!(:restaurants) { create(:expense_category, name: "Restaurants") }
  let!(:rent) { create(:expense_category, name: "Rent") }

  describe "#income" do
    it "returns an array with a summary for each category" do
      create(:transaction, cents: 100, category: work)
      create(:transaction, cents: 150, category: work)

      income = subject.income

      expect(income.length).to eq 1

      first = income.first

      expect(first.category).to eq work
      expect(first.cents).to eq 250
    end

    it "does not include non-income categories" do
      create(:transaction, cents: 100, category: restaurants)

      expect(subject.income).to be_empty
    end

    it "sorts the results by cents per category descending" do
      create(:transaction, cents: 100, category: work)
      create(:transaction, cents: 250, category: bonus)

      expect(subject.income.map(&:category)).to eq [bonus, work]
    end

    it "doesn't include transactions outside the current month" do
      create(:transaction, cents: 1, category: work, date: Time.now.at_beginning_of_month - 1.day)
      create(:transaction, cents: 10, category: work, date: Time.now.at_beginning_of_month)
      create(:transaction, cents: 100, category: work, date: Time.now)
      create(:transaction, cents: 1000, category: work, date: Time.now.at_end_of_month)
      create(:transaction, cents: 10000, category: work, date: Time.now.at_end_of_month + 1.day)

      expect(subject.income.first.cents).to eq 1110
    end

    it "does not include transactions belonging to a debt account" do
      create(:transaction, cents: 100, category: work, account: create(:debt_account))

      expect(subject.income).to be_empty
    end
  end

  describe "#expenses" do
    it "returns an array with a summary for each category" do
      create(:transaction, cents: 100, category: restaurants)
      create(:transaction, cents: 150, category: restaurants)

      expenses = subject.expenses

      expect(expenses.length).to eq 1

      first = expenses.first

      expect(first.category).to eq restaurants
      expect(first.cents).to eq 250
    end

    it "does not include non-expense categories" do
      create(:transaction, cents: 100, category: work)

      expect(subject.expenses).to be_empty
    end

    it "sorts the results by cents per category descending" do
      create(:transaction, cents: 100, category: restaurants)
      create(:transaction, cents: 250, category: rent)

      expect(subject.expenses.map(&:category)).to eq [rent, restaurants]
    end

    it "doesn't include transactions outside the current month" do
      create(:transaction, cents: 1, category: rent, date: Time.now.at_beginning_of_month - 1.day)
      create(:transaction, cents: 10, category: rent, date: Time.now.at_beginning_of_month)
      create(:transaction, cents: 100, category: rent, date: Time.now)
      create(:transaction, cents: 1000, category: rent, date: Time.now.at_end_of_month)
      create(:transaction, cents: 10000, category: rent, date: Time.now.at_end_of_month + 1.day)

      expect(subject.expenses.first.cents).to eq 1110
    end

    it "does not include transactions belonging to a debt account" do
      create(:transaction, cents: 100, category: rent, account: create(:debt_account))

      expect(subject.expenses).to be_empty
    end

  end

  describe "#net_income" do
    it "is the number of cents difference between the income and expense categories" do
      create(:transaction, cents: 10000, category: work)
      create(:transaction, cents: 200, category: rent)
      create(:transaction, cents: 50, category: restaurants)

      expect(subject.net_income).to eq 9750
    end

    it "does not include debt in the calculation" do
      create(:transaction, cents: 100, category: rent, account: create(:debt_account))

      expect(subject.net_income).to eq 0
    end
  end
end