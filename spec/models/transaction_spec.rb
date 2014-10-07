require 'rails_helper'

describe Transaction do

  describe "validation" do
    it "requires an account" do
      expect(build(:transaction, account: nil)).not_to be_valid
    end

    it "requires a category" do
      expect(build(:transaction, category: nil)).not_to be_valid
    end

    it "requires the amount" do
      expect(build(:transaction, cents: nil)).not_to be_valid
    end

    it "requires the date" do
      expect(build(:transaction, date: nil)).not_to be_valid
    end

    it "requires a description" do
      expect(build(:transaction, description: nil)).not_to be_valid
    end
  end

end