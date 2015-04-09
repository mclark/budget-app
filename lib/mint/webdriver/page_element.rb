require 'mint/webdriver/dsl'
require 'budget/null_logger'

module Mint
  module Webdriver
    class PageElement
      include DSL

      def initialize(driver, logger: Budget::NullLogger)
        @driver = driver
        @logger = logger
      end

      def wait_for(timeout = 15)
        Selenium::WebDriver::Wait.new(:timeout => timeout).until { yield }
      end

      def wait_for_selector(selector, type: :css, timeout: 15)
        wait_for(timeout) { exists?(selector, type: type) }
      end

      def wait_for_missing_selector(selector, type: :css, timeout: 15)
        wait_for(timeout) { !exists?(selector, type: type) }
      end

    protected
      attr_reader :driver, :logger

    end
  end
end
