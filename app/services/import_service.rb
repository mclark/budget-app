require 'mint/client'

class ImportService
  ImportError = Class.new(StandardError)

  def initialize(logger: Mint::NullLogger)
    @logger = logger
  end

  def call
    begin
      client.go_login!
      client.go_transactions!

      client.accounts.each do |acc|
        MintAccount.find_or_initialize_by(mint_id: acc.id) do |a|
          a.name = acc.name
        end.save
      end

      client.transactions.each do |txn|
        MintTransaction.find_or_initialize_by(mint_id: txn.id) do |t|
          t.date = txn.date
          t.description = txn.description
          t.category = txn.category
          t.cents = txn.cents
          t.expense = txn.is_expense
          t.account = txn.account
          t.account_id = txn.account_id
          t.notes = txn.notes
        end.save
      end
    rescue StandardError => error
      raise ImportError.new(error.message)
    ensure
      client.shutdown!
    end
  end

private
  attr_reader :logger

  def client
    @client ||= Mint::Client.new(Figaro.env.mint_username, Figaro.env.mint_password, logger: logger)
  end

end