require 'mint/webdriver/page_element'

module Mint
  module Webdriver
    class LandingPage < PageElement

      def wait_for_loaded!
        wait_for_selector("#login_button")
      end

      def login
        sleep(1) # the page is often not interactive once "loaded" there is something missing but it's hard to track down
        click("#login_button")
      end

    end
  end
end