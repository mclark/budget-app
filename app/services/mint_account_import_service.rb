require 'service_response'

class MintAccountImportService

  def initialize(mint_account, params)
    @mint_account = mint_account
    @params = params
  end

  def call
    account = Account.new(params)

    if account.valid?
      Account.transaction do
        account.save!
        mint_account.update_attribute :imported_id, account.id
      end

      ServiceResponse::SUCCESS
    else
      mint_account.attributes = params
      mint_account.valid?

      ServiceResponse::FAILURE
    end
  end

private
  attr_reader :mint_account, :params

end