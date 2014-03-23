module ApplicationHelper

  def review_count
    @review_count ||= MintAccount.count + MintTransaction.count
  end

  def transactions_count
    @transactions_count ||= Transaction.count
  end

  def cents_to_dollars(cents)
    (cents / 100.0).round(2)
  end  

end
