# require_relative 'transaction'
# require_relative 'account'

# module Mint
#   class TransactionsPage < PageObject
#     @@expected_path  = "/transaction.event"

#     def accounts
#       browser.find_all("#localnav li[id*=account-]").map do |acc|
#         id = acc["id"].split("-").last.to_i
#         name = acc.text("small")

#         next if id == 0

#         Account.new(id: id, name: name)
#       end.compact
#     end

#     def transactions
#       account_ids = Hash[accounts.map {|a| [a.name, a.id] }]

#       browser.find_all("#transaction-list tbody tr").map do |txn|
#         next if txn["class"].split.include?("hide")

#         id    = txn["id"].split("-").last.to_i
#         date  = txn.text(".date")
#         desc  = txn.attribute(".description", "title").gsub("Statement Name:", "").strip
#         cat   = txn.text(".cat")
#         cents = txn.text(".money").gsub(/\D+/, '').to_i
#         exp   = !txn["class"].split.include?("positive")

#         # open the edit mode to get more data
#         selected_id = browser.attribute("#txnEdit-txnId", "value").split(":").first.to_i

#         txn.click("td.money") unless id == selected_id
#         browser.click("#txnEdit-toggle")
#         sleep(0.1)

#         notes = browser.attribute("#txnEdit-note", "value").strip

#         account = browser.text("#txnEdit-details .txn-edit-group p.regular .var-nickname").strip

#         account_id = account_ids[account]

#         # close the editor
#         browser.click("#txnEdit-cancel")
#         sleep(0.1)

#         Transaction.new(
#           id: id, 
#           date: date, 
#           description: desc, 
#           category: cat, 
#           cents: cents, 
#           is_expense: exp, 
#           notes: notes, 
#           account_id: account_id,
#           account: account
#         )
#       end.compact
#     end
    
#     def wait_for_ajax_load!
#       wait_for { browser.find_all("#transaction-paging").any? }
#       sleep(5.0)
#     end

#     def page
#       browser.text("#transaction-paging .empty").to_i
#     end

#     def page_count
#       browser.find_all("#transaction-paging > li").length - 2
#     end

#     def first_page?
#       browser.find_all("#transaction-paging .prev").none?
#     end

#     def last_page?
#       browser.find_all("#transaction-paging .next").none?
#     end

#     def next_page!
#       cpage = page
#       browser.click("#transaction-paging .next a")
#       wait_for { page != cpage }
#       sleep(0.1)
#     end

#   end
# end