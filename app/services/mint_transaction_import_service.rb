require 'service_response'

class MintTransactionImportService

  def initialize(mint, txn, params)
    @mint = mint
    @txn = txn
    @params = params
  end

  def call
    ServiceResponse::FAILURE
  end

private
  attr_reader :mint, :txn, :params

end