require 'transaction_factory'

class MintTransactionsController < ApplicationController
  include ReviewConcern

  def show
    # TODO: check if the transaction is already imported and if so render a different page
    @imported_transaction = TransactionFactory.build_with_inference_from_mint_transaction(mint_transaction)
  end

  def update
    # TODO: missing features
    # - mark as a duplicate of existing transaction
    # - reject (do not import)
    # - push off for later review
    @imported_transaction = (mint_transaction.expense ? Expense : Income).new(filtered_params)

    if MintTransactionImportService.new(mint_transaction, imported_transaction, filtered_params).call.success?
      redirect_to next_review_url
    else
      render 'show'
    end
  end

private
  attr_reader :imported_transaction
  helper_method :imported_transaction

  def filtered_params
    params.require(:transaction).permit(:cents, :account_id, :category_id, :date, :description, :notes)
  end
  
  def mint_transaction
    @_mint_transaction ||= MintTransaction.find(params[:id])
  end
  helper_method :mint_transaction

end