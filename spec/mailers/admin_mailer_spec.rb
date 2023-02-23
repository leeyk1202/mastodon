# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminMailer, type: :mailer do
  describe '.new_report' do
    let(:sender)    { Fabricate(:account, username: 'John') }
    let(:recipient) { Fabricate(:account, username: 'Mike') }
    let(:report)    { Fabricate(:report, account: sender, target_account: recipient) }
    let(:mail)      { described_class.new_report(recipient, report) }

    before do
      recipient.user.update(locale: :en)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq("New report for cb6e6126.ngrok.io (##{report.id})")
      expect(mail.to).to eq [recipient.user_email]
      expect(mail.from).to eq ['notifications@localhost']
    end

    it 'renders the body' do
      expect(mail.body.encoded).to eq("Mike,\r\n\r\nJohn has reported Mike\r\n\r\nView: https://cb6e6126.ngrok.io/admin/reports/#{report.id}\r\n")
    end
  end

  describe '.new_appeal' do
    let(:appeal) { Fabricate(:appeal) }
    let(:recipient) { Fabricate(:account, username: 'Kurt') }
    let(:mail)      { described_class.new_appeal(recipient, appeal) }

    before do
      recipient.user.update(locale: :en)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq("#{appeal.account.username} is appealing a moderation decision on cb6e6126.ngrok.io")
      expect(mail.to).to eq [recipient.user_email]
      expect(mail.from).to eq ['notifications@localhost']
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match "#{appeal.account.username} is appealing a moderation decision by #{appeal.strike.account.username}"
    end
  end

  describe '.new_pending_account' do
    let(:recipient) { Fabricate(:account, username: 'Barklums') }
    let(:user) { Fabricate(:user) }
    let(:mail) { described_class.new_pending_account(recipient, user) }

    before do
      recipient.user.update(locale: :en)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq("New account up for review on cb6e6126.ngrok.io (#{user.account.username})")
      expect(mail.to).to eq [recipient.user_email]
      expect(mail.from).to eq ['notifications@localhost']
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match 'The details of the new account are below. You can approve or reject this application.'
    end
  end
end
