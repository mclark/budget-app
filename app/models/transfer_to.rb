
class TransferTo < Income
  has_one :from, class_name: "TransferFrom", foreign_key: "transfer_id"

  def to
    self
  end
end