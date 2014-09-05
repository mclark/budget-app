require 'mint/webdriver/page_element'

module Mint
  module Webdriver
    class LandingPage < PageElement

      def wait_for_loaded!
        wait_for_selector("#login_button")
      end

      def login
        click("#login_button")
      end

    end
  end
end