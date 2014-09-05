require 'mint/client/state_machine'
require 'mint/webdriver/login_page'
require 'mint/webdriver/overview_page'
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
    end

    #TODO: create a repository object for each of these sets
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

    def perform_login(event)
      @current_page = Webdriver::LoginPage.new(driver)

      #TODO: extract into LandingPage object
      current_page.goto(domain)

      current_page.wait_for_selector("#login_button")

      current_page.click("#login_button")

      current_page.wait_for_loaded!

      current_page.login(email, password) do
        state_machine.logged_in!
      end
    end

    def load_page(event)
      @current_page = 
        case event.to
        when "overview_loading" then Webdriver::OverviewPage.new(driver)
        when "transactions_loading" then raise NotImplementedError
        else raise "unhandled state: #{event.to.inspect}"
        end

      current_page.wait_for_loaded!

      state_machine.send("navigated_to_#{event.to.to_s.gsub("_loading","")}!")
    end

    def load_alerts(event)
      logger.debug "load_alerts"
      alerts.merge(current_page.alerts)
    end

    def load_accounts(event)
      logger.debug "load_accounts"
      accounts.merge(current_page.accounts)
    end

    def load_transactions(event)
      logger.debug "load_transactions"
      transactions.merge(current_page.transactions)
    end

    # def do_transactions!
    #   driver.click("#transaction a")
    # end

    # def load_transactions
    #   page = TransactionsPage.new(driver)
    #   page.wait_for_ajax_load!
    #   page.assert_page!

    #   loop do
    #     #TODO: do a more intelligent merge
    #     transactions.merge(page.transactions)

    #     if page.last_page?
    #       logger.debug("found last page of transactions - done importing")
    #       break
    #     else
    #       logger.debug("loading next page of transactions")
    #       page.next_page!
    #     end
    #   end
    # end

  private
    attr_reader :email, :password, :domain, :driver, :current_page

  end
end