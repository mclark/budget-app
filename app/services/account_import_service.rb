require 'service_response'

class AccountImportService

  def initialize(importable_account, params)
    @importable_account = importable_account
    @params = params
  end

  def call
    account = Account.new(params)

    if account.valid?
      Account.transaction do
        account.save!
        importable_account.update_attribute :imported_id, account.id
      end

      ServiceResponse::SUCCESS
    else
      importable_account.attributes = params
      importable_account.valid?

      ServiceResponse::FAILURE
    end
  end

private
  attr_reader :importable_account, :params

end
