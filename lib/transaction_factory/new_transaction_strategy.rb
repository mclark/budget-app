require 'transaction_similarity_analyzer'

module TransactionFactory
  class NewTransactionStrategy < Struct.new(:txn)

    def call
      trans = txn.expense ? Expense.new : Income.new

      trans.account = txn.importable_account.try(:account)

      trans.date = txn.date

      trans.description = txn.description

      trans.cents = txn.cents

      trans.notes = txn.notes

      trans.category = Category.find_by(name: txn.category) ||
                       TransactionSimilarityAnalyzer.new(trans).best_category ||
                       ImportableCategory.best_match(txn.category)

      trans
    end

  end
end
