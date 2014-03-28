
class TransferizeService

  def initialize(from, to)
    @from = from
    @to = to
  end

  def call
    from.category = Category.transfer_from
    from.type = TransferFrom.name
    from.transfer_id = to.id

    to.category = Category.transfer_to
    to.type = TransferTo.name
    to.transfer_id = from.id

    Transaction.transaction do
      from.save!
      to.save!
    end
  end

private
  attr_reader :from, :to

end