require 'mint/client/state_machine'
require 'mint/webdriver/landing_page'
require 'mint/webdriver/overview_page'
require 'mint/webdriver/transactions_page'
require 'mint/null_logger'

module Mint
  #TODO: this is really a driver - the client should instrument it (perform actions to load data it wants)
  class Client

    attr_reader :logger, :state_machine

    def initialize(driver, email, password, domain: "http://www.mint.com", logger: NullLogger)
      @driver = driver

      @email = email

      @password = password

      @domain = domain

      @logger = logger

      @state_machine = Client::StateMachine.new(self)

      @current_page = Webdriver::LandingPage.new(driver)
      @current_page.goto(domain)
    end

    def accounts
      @accounts ||= Set.new
    end

    def alerts
      @alerts ||= Set.new
    end

    def transactions
      @transactions ||= Set.new
    end

    def shutdown!
      driver.close
    end

# -- 'Friend Methods' - please treat these as private --------------------------

    def visit_transactions
      driver.find_element(:css, "#transaction a").click
    end

    def perform_login
      current_page.login(email, password) do
        state_machine.logged_in!
      end
    end

    def load_page(page_name)
      @current_page = 
        case page_name
        when "overview_loading" then Webdriver::OverviewPage.new(driver)
        when "transactions_loading" then Webdriver::TransactionsPage.new(driver)
        else raise "unhandled state: #{page_name.inspect}"
        end

      current_page.wait_for_loaded!

      state_machine.send("navigated_to_#{page_name.gsub("_loading","")}!")
    end

    def load_alerts
      logger.debug "load_alerts"
      alerts.merge(current_page.alerts)
    end

    def load_accounts
      logger.debug "load_accounts"
      accounts.merge(current_page.accounts)
    end

    def load_transactions
      logger.debug "load_transactions"
      transactions.merge(current_page.transactions)
    end

  private
    attr_reader :email, :password, :domain, :driver, :current_page

  end
end