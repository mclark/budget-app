
module TransactionFactory
  class DuplicateTransactionStrategy < Struct.new(:mint)

    def call
      scope = base_scope
      scope = scope.where(account: imported_account) if imported_account
      scope.first
    end

  private

    def imported_account
      mint.mint_account.try(:account)
    end

    def imported_type
      mint.expense ? Expense : Income
    end

    # a scope that matches all transactions on attributes which must match
    def base_scope
      Transaction.where(cents: mint.cents, type: imported_type)
                 .where("date between ? and ?", mint.date - 1.day, mint.date + 1.day)
    end

  end
end
