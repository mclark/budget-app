require 'csv'
require 'budget/null_logger'
require 'pc_financial/client'
require 'pc_financial/import_controller'
require 'digest/sha1'

class PcFinancialImportService
  def initialize(logger: Budget::NullLogger,
      controller: nil)

    @logger = logger
    if controller.nil?
      client = PcFinancial::Client.new(Figaro.env.pc_financial_client_num,
                                       Figaro.env.pc_financial_password,
                                       logger: logger)
      @controller = PcFinancial::ImportController.new(client)
    else
      @controller = controller
    end
  end

  attr_reader :logger

  def call(accounts: nil, since: nil)
    txn_data = @controller.fetch(accounts: accounts, since: since)

    logger.info "ingesting transactions..."

    txn_data.each_pair do |account, txns|
      a = ImportableAccount.find_or_initialize_by(source_id: account)
      a.name = account
      a.save

      txns.each do |txn|
        t = ImportableTransaction.find_or_initialize_by(source_id: txn.id)

        t.date = txn.date
        t.description = txn.notes
        t.category = "unknown"
        t.expense = txn.expense?
        t.cents = txn.amount
        t.account = account
        t.account_id = a.id
        t.source_id = txn.id
        t.save
      end
    end
  end
end
