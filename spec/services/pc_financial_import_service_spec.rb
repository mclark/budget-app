require_relative '../rails_helper'

require 'pc_financial/transaction'
require 'pc_financial/import_controller'

describe PcFinancialImportService do
  def txn(date, notes, id, debit, credit = nil)
    PcFinancial::Transaction.new(date: date, notes: notes,
      id: id, debit: debit, credit: credit)
  end

  let(:controller) { double(:controller) }

  before do
    expect(controller).to receive(:fetch).and_return({
      "123" => [txn('4/4/2014', 'test1', 'abc123', '45.22')]
    })

    PcFinancialImportService.new(controller: controller).call
  end

  it 'creates accounts and transactions for fetched data' do
    account = ImportableAccount.find_by(source_id: '123')
    expect(account).to_not be_nil

    txn = ImportableTransaction.find_by(source_id: 'abc123')
    expect(txn).to_not be_nil
    expect(txn.description).to eql('test1')
    expect(txn.date).to eql(Date.new(2014, 4, 4))
    expect(txn).to be_expense
    expect(txn.cents).to eql(4522)
    expect(txn.account).to eql('123')
    expect(txn.account_id).to eql(account.id)
  end
end
