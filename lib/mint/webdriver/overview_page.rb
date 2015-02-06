require 'mint/model/alert'
require 'mint/model/account'
require 'mint/webdriver/page_element'

module Mint
  module Webdriver
    class OverviewPage < PageElement

      def wait_for_loaded!
        wait_for_selector(".overviewPage")

        if Mint.force_refresh && exists?("#module-accounts-update") && !exists?("#module-accounts-update.disabled")
          click("#module-accounts-update")
          sleep(1.0)
        end

        if exists?("#systemMessages .refresh-message")
          wait_for_selector("#systemMessages .refresh-message-done", timeout: 120)
        end
      end

      def alerts
        #TODO: not sure if this actually works - will need a fresh account to test
        return [] unless exists?("#module-alert")
        
        wait_for_selector("#module-alert .alert-list > li")

        if exists?("#module-alert .see_all_button")
          sleep(0.25)
          click("#module-alert .see_all_button")
        end

        find_all("#module-alert .alert-list li").map do |alert|
          text = alert.text(".headline")
          date = alert.text(".date")

          Alert.new(text: text, date: date)
        end
      end

      def accounts
        wait_for_selector(".accounts-list")

        find_all(".accounts-list > li.accounts-data-li").map do |account|
          id = account["id"].split("-").last.to_i
          name = account.text(".nickname")

          Mint::Account.new(id: id, name: name)
        end
      end
    end
  end
end