class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :category

  validates :account, presence: true
  validates :category, presence: true
  validates :cents, presence: true
  validates :date, presence: true
  validates :description, presence: true
end
