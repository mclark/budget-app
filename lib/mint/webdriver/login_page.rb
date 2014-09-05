require 'mint/webdriver/page_element'

module Mint
  module Webdriver
    class LoginPage < PageElement

      def wait_for_loaded!
        wait_for_selector("#form-login")
      end

      def login(email, password, &callback)
        # fill in the login form
        type("input[name=email]", email)
        type("input[name=password]", password)
        click("#submit")

        # busy wait on AJAX submit
        wait_for_missing_selector("#form-login")

        # let them know we're done logging in
        callback.call
      end

    end
  end
end