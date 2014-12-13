class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.mail_recipient,
          to: Figaro.env.mail_recipient

  def review_reminder
    @txn_count = MintTransaction.not_imported.count
    @acc_count = MintAccount.not_imported.count

    mail(subject: "You have stuff to review!")
  end
end
