
module Mint
  module Model

    def self.new(*args, &block)
      klass = Struct.new(*args, &block)
      klass.send(:include, InstanceMethods)
      klass
    end

    module InstanceMethods

      def initialize(attrs={})
        super(*members.map {|m| attrs[m.to_sym]})
      end

      def primary_key
        if members.include?("id")
          self.id
        else
          raise NotImplementedError
        end
      end

    end

  end
end