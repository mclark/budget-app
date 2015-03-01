class Expense < Transaction


  def signed_cents
    -cents
  end

end