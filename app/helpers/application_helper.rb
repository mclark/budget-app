module ApplicationHelper

  def review_count
    @review_count ||= MintAccount.not_imported.count + MintTransaction.not_imported.count
  end

  def transactions_count
    @transactions_count ||= Transaction.count
  end

  def cents_to_dollars(cents)
    if cents
      (cents / 100.0).round(2)
    else
      0.00
    end
  end  

  def page_header(header="")
    content_tag(:div, class: "page-header") do
      content_tag(:h1, header)
    end
  end

end
