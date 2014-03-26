require 'service_response'

class MintTransactionImportService

  def initialize(mint, txn, params)
    @mint = mint
    @txn = txn
    @params = params
  end

  def call
    if txn.valid?
      Transaction.transaction do
        txn.save!
        
        mint.update_attribute :imported_id, txn.id

        MintCategory.find_or_create_by(name: mint.category, imported_id: txn.category_id).increment!(:import_count)
      end

      ServiceResponse::SUCCESS
    else
      ServiceResponse::FAILURE
    end
  end

private
  attr_reader :mint, :txn, :params
  
end