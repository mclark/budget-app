require 'transaction_similarity_analyzer'

module TransactionFactory
  class NewTransactionStrategy < Struct.new(:mint)

    def call
      trans = mint.expense ? Expense.new : Income.new

      trans.account = mint.mint_account.try(:account)

      trans.date = mint.date

      trans.description = mint.description

      trans.cents = mint.cents

      trans.notes = mint.notes

      trans.category = Category.find_by(name: mint.category) ||
                       TransactionSimilarityAnalyzer.new(trans).best_category ||
                       MintCategory.best_match(mint.category)

      trans
    end

  end
end