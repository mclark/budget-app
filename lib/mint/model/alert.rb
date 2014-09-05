require 'chronic'
require 'mint/model'

module Mint
  class Alert < Model.new(:text, :date) 

    def parsed_date
      if %r[\d{2}/\d{2}/\d{2}].match(date)
        Time.strptime date, "%m/%d/%y"
      else
        Chronic.parse "#{date} #{Time.now.year}"
      end
    end
  
  end
end