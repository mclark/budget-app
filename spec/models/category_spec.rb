require 'rails_helper'

describe Category do

  describe "validations" do
    it "can only be Income, Expense or Transfer when it is a root category" do
      expect(build(:category, parent: nil, name: "Foo")).not_to be_valid
    end
  end

end