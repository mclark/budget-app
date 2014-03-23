
class MintTransactionsController < ApplicationController
  include ReviewConcern

  def show
    # TODO: check if the transaction is already imported and if so render a different page
    mint_transaction # force load
  end

  def update
  end

private
  
  def mint_transaction
    @_mint_transaction ||= MintTransaction.find(params[:id])
  end
  helper_method :mint_transaction

  def imported_transaction
    @_imported_transaction ||= Transaction.new #TODO: replace with value generated from pre-filler object
  end
  helper_method :imported_transaction

end