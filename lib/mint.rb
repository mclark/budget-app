require 'mint/client'

module Mint
  extend self
  
  # only imports transactions from the given date or later
  attr_accessor :since_date

  # always refresh accounts when hitting the overview page
  attr_accessor :force_refresh
end