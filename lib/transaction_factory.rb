require 'transaction_factory/new_transaction_strategy'
require 'transaction_factory/duplicate_transaction_strategy'

module TransactionFactory

  def self.build_with_inference_from_importable_transaction(txn)
    [
      DuplicateTransactionStrategy.new(txn),
      NewTransactionStrategy.new(txn)
    ].each {|strategy| value = strategy.call; break value if value }
  end
end
