module Budget
  module NullLogger

    %i(debug info warn error critical).each do |level|
      define_method(level) {|*args, &block|}
      define_singleton_method(level) {|*args, &block|}
    end

  end
end
