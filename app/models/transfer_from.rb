
class TransferFrom < Expense
  has_one :to, class_name: "TransferTo", foreign_key: "transfer_id"

  def from
    self
  end
end