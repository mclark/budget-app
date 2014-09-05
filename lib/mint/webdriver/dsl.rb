require 'mint/null_logger'

module Mint
  module Webdriver
    module DSL

      def driver
        raise NotImplementedError
      end

      def logger
        Mint::NullLogger
      end

      def goto(url)
        logger.debug("going to #{url}")
        driver.get(url)
        nil
      end
      
      def path
        URI.parse(driver.current_url).path
      end

      def title
        driver.title
      end

      def [](attribute)
        driver.attribute(attribute)
      end

      def find(selector, type: :css)
        Element.new driver.find_element(type, selector), logger
      end

      def find_all(selector, type: :css)
        driver.find_elements(type, selector).map {|n| Element.new(n, logger) }
      end

      def click(selector, type: :css)
        logger.debug("clicking #{type}:#{selector.inspect}")
        driver.find_element(type, selector).click
        nil
      end

      def type(selector, value, type: :css)
        logger.debug("typing #{value} on #{type}:#{selector.inspect}")
        driver.find_element(type, selector).send_keys(value)
        nil
      end

      def text(selector, type: :css)
        value = driver.find_element(type, selector).text
        logger.debug("fetching text for #{type}:#{selector.inspect}: #{value.inspect}")
        value
      end

      def attribute(selector, name, type: :css)
        value = driver.find_element(type, selector).attribute(name)
        logger.debug("fetching value for attribute #{name} on #{type}:#{selector.inspect}: #{value}")
        value
      end

      def exists?(selector, type: :css)
        find_all(selector, type: type).any?
      end

      def visible?(selector, type: :css)
        exists?(selector, type: type) && driver.find_element(selector, type: type).displayed?
      end

      def screenshot(filename)
        logger.debug("saving screenshot")
        driver.save_screenshot(filename)
      end

    end

    class Element
      include DSL

      def initialize(driver, logger)
        @driver = driver
        @logger = logger
      end

    private
      attr_reader :driver, :logger
    end
  end
end