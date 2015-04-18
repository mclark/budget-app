require 'service_response'

class TransactionImportService

  def initialize(importable, txn, params)
    @importable = importable
    @txn = txn
    @params = params
  end

  def call
    if txn.valid?
      Transaction.transaction do
        txn.save!
        
        importable.update_attribute :imported_id, txn.id

        ImportableCategory.find_or_create_by(name: importable.category, imported_id: txn.category_id).increment!(:import_count)
      end

      ServiceResponse::SUCCESS
    else
      ServiceResponse::FAILURE
    end
  end

private
  attr_reader :importable, :txn, :params
  
end
