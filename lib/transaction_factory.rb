require 'transaction_factory/new_transaction_strategy'
require 'transaction_factory/duplicate_transaction_strategy'

module TransactionFactory

  def self.build_with_inference_from_mint_transaction(mint)
    [
      DuplicateTransactionStrategy.new(mint),
      NewTransactionStrategy.new(mint)
    ].each {|strategy| value = strategy.call; break value if value }
  end
end