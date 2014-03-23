
module ReviewConcern
  extend ActiveSupport::Concern

  def next_review_url
    if obj = unimported_accounts.first || unimported_transactions.first
      url_for obj
    else
      flash[:notice] = "You're all done! no more stuff to review."
      root_path
    end
  end

private

  def unimported_accounts
    MintAccount.not_imported
  end

  def unimported_transactions
    MintTransaction.not_imported
  end

end