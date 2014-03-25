require 'transaction_factory'

class MintTransactionsController < ApplicationController
  include ReviewConcern

  def show
    # TODO: check if the transaction is already imported and if so render a different page
    imported_transaction # force load
  end

  def update
    # TODO: missing features
    # - mark as a duplicate of existing transaction
    # - reject (do not import)
    # - push off for later review
    if MintTransactionImportService.new(mint_transaction, imported_transaction, filtered_params).call.success?
      redirect_to next_review_url
    else
      render 'show'
    end
  end

private

  def filtered_params
    params.require(:transaction).permit!
  end
  
  def mint_transaction
    @_mint_transaction ||= MintTransaction.find(params[:id])
  end
  helper_method :mint_transaction

  def imported_transaction
    @_imported_transaction ||= TransactionFactory.build_with_inference_from_mint_transaction(mint_transaction)
  end
  helper_method :imported_transaction

end