
module Mint
  module NullLogger

    class << self
      %i(debug info warn error critical).each do |level|
        define_method(level) {|*args,&block|}
      end
    end

  end
end