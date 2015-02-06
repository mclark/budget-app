require 'mint/webdriver/page_element'

module Mint
  module Webdriver
    class LandingPage < PageElement

      def wait_for_loaded!
        wait_for_selector(".login-signup-menu .js-auth-slider-toggle--login")
      end

      def login(email, password, &callback)
        click(".login-signup-menu .js-auth-slider-toggle--login")

        wait_for { visible?("#edit-username") }

        # fill in the login form
        type("#edit-username", email)
        type("#edit-password", password)
        click("#mint-auth-mint-com-login-form button")

        # let them know we're done logging in
        callback.call
      end

    end
  end
end