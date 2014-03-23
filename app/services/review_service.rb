
class ReviewService

  def initialize(handler)
    @handler = handler
  end

  def call
    MintAccount.not_imported.find_each do |mint|
      Account.transaction do
        acc = Account.create(name: mint.name)
        mint.update_attribute :imported_id, acc.id
      end
    end

    MintTransaction.not_imported.find_each do |mint|
      txn = Transaction.new do |t|
        t.date = mint.date
        t.date = mint.date
        t.description = mint.description
        t.category = mint.category
        t.cents = mint.cents
        t.expense = mint.is_expense
        t.account = mint.account
        t.account_id = mint.account_id
        t.notes = mint.notes
      end

      handler.verify_transaction(mint, txn)

      Transaction.transaction do
        txn.save!
        mint.update_attribute :imported_id, txn.id
      end
    end
  end

private
  attr_reader :handler

end