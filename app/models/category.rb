
class Category < ActiveRecord::Base
  acts_as_tree
  has_many :transactions
end
