require 'mint/model/transaction'
require 'mint/model/account'
require 'mint/webdriver/page_element'
require 'set'

module Mint
  module Webdriver
    class TransactionsPage < PageElement

      def wait_for_loaded!
        wait_for_selector("#transaction-list")
        wait_for_missing_selector("#main.loading")
        load_transactions!
      end

      def accounts
        find_all("#localnav li[id*=account-]").map do |acc|
          id = acc["id"].split("-").last.to_i
          name = acc.text("small")

          next if id == 0

          Account.new(id: id, name: name)
        end.compact
      end

      def transactions
        @transactions ||= Set.new
      end

    private

      def pager
        @pager ||= Pager.new(driver)
      end

      def account_nickname_map
        accounts.map {|a| [a.name, a.id] }.to_h
      end

      def load_transactions!
        loop do
          load_page_transactions!

          break if pager.last_page?

          pager.next_page!
        end
      end

      def load_page_transactions!
        id_list = []

        find_all("#transaction-list > tbody > tr").each do |row|
          next if row["class"].split.include?("hide")

          id_list << row["id"]
        end

        id_list.map do |dom_id|
          transactions << TransactionRow.new(driver, dom_id, account_nickname_map).transaction
        end
      end

      class Pager < PageElement
        def last_page?
          find_all("#transaction-paging .next").none?
        end

        def next_page!
          click("#transaction-paging .next a")
          wait_for_missing_selector("#main.loading")
        end
      end

      class TransactionRow < PageElement

        def initialize(driver, dom_id, account_ids)
          super(driver)
          @dom_id = "##{dom_id}"
          @account_ids = account_ids
        end

        def transaction
          Transaction.new(
            id: transaction_id, 
            date: date, 
            description: desc, 
            category: cat, 
            cents: cents, 
            is_expense: expense?, 
            notes: notes, 
            account_id: account_id,
            account: account_nickname
          )
        end

        def transaction_id
          dom_id.split("-").last.to_i
        end

        def date
          text "#{dom_id} .date"
        end

        def desc
          attribute("#{dom_id} .description", "title").gsub("Statement Name:", "").strip
        end

        def cat
          text "#{dom_id} .cat"
        end

        def cents
          text("#{dom_id} .money").gsub(/\D+/, '').to_i
        end

        def expense?
          attribute(dom_id, "class").split.exclude?("positive")
        end

        def account_nickname
          @account_nickname ||= load_details && @account_nickname
        end

        def account_id
          @account_id ||= load_details && @account_id
        end

        def notes
          @notes ||= load_details && @notes
        end

      private
        attr_reader :dom_id, :account_ids

        def load_details
          # highlight the row we want to "edit" unless it's already highlighted
          selected_id = attribute("#txnEdit-txnId", "value").split(":").first.to_i

          click("#{dom_id} td.money") unless transaction_id == selected_id

          # open the transaction for "editing mode"
          click("#txnEdit-toggle")
          wait_for_missing_selector("#txnEdit-form.hide")
          sleep 0.25

          # grab the data
          @notes = attribute("#txnEdit-note", "value").strip

          @account_nickname = text("#txnEdit-details .txn-edit-group p.regular .var-nickname").strip

          @account_id = account_ids[@account_nickname]

          # close the editor
          click("#txnEdit-cancel")
          wait_for_selector("#txnEdit-form.hide")

          # return true to enable chaining
          true
        end

      end    

    end
  end
end