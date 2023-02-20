# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Poll do
  describe '#final?' do
    subject(:poll) { described_class.new(account: Account.new) }

    context 'when poll is local' do
      it 'returns false when not expired' do
        expect(poll.final?).to be false
      end

      it 'returns true when expired' do
        poll.expires_at = 5.minutes.ago
        expect(poll.final?).to be true
      end
    end

    context 'when poll is remote' do
      before do
        poll.account.domain = 'example.com'
      end

      it 'returns false if not expired' do
        expect(poll.final?).to be false
      end

      it 'returns false if fetched before expiration' do
        poll.expires_at = 5.minutes.ago
        poll.last_fetched_at = 10.minutes.ago
        expect(poll.final?).to be false
      end

      it 'returns true if fetched after expiration' do
        poll.expires_at = 5.minutes.ago
        poll.last_fetched_at = 1.minute.ago
        expect(poll.final?).to be true
      end
    end
  end
end
