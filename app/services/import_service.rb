require 'mint'

class ImportService
  def initialize(logger: Mint::NullLogger)
    @logger = logger
  end

  def call
    begin
      client.state_machine.navigate_to_login

      client.state_machine.login

      client.state_machine.navigate_to_transactions

      client.accounts.each do |acc|
        a = MintAccount.find_or_initialize_by(mint_id: acc.id)
        a.name = acc.name
        a.save
      end

      client.transactions.each do |txn|
        t = MintTransaction.find_or_initialize_by(mint_id: txn.id)
        t.date = txn.parsed_date
        t.description = txn.description
        t.category = txn.category
        t.cents = txn.cents
        t.expense = txn.is_expense
        t.account = txn.account
        t.account_id = txn.account_id
        t.notes = txn.notes
        t.save
      end
    ensure
      client.shutdown!
    end
  end

private
  attr_reader :logger

  def driver
    @driver ||= Selenium::WebDriver.for(Figaro.env.selenium_driver.to_sym)
  end

  def client
    @client ||= Mint::Client.new(driver, Figaro.env.mint_username, Figaro.env.mint_password, logger: logger)
  end

end