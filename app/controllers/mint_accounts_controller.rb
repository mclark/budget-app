
class MintAccountsController < ApplicationController
  include ReviewConcern

  def show
    # TODO: check if the account is already imported and if so render a different page
    account # force load
  end

  def update
    # TODO: missing features
    # - merge a mint account into an existing account
    # - reject an account (do not import)
    # - push off an account for later review
    if MintAccountImportService.new(account, filtered_params).call.success?
      redirect_to next_review_url
    else
      render 'show'
    end
  end

private

  def filtered_params
    params.require(:mint_account).permit(:name)
  end
  
  def account
    @_account ||= MintAccount.find(params[:id])
  end
  helper_method :account

end