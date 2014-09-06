require 'mint/client'

module Mint
  extend self
  
  # only imports transactions from the given date or later
  attr_accessor :since_date
end