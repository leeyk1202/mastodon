# frozen_string_literal: true

require 'rails_helper'

describe 'Settings / Exports / Following Accounts' do
  describe 'GET /settings/exports/follows' do
    context 'with a signed in user who is following accounts' do
      let(:user) { Fabricate :user }

      before do
        Fabricate(
          :follow,
          account: user.account,
          target_account: Fabricate(:account, username: 'username', domain: 'domain'),
          languages: ['en']
        )
        sign_in user
      end

      it 'returns a CSV with the accounts' do
        get '/settings/exports/follows.csv'

        expect(response)
          .to have_http_status(200)
        expect(response.body)
          .to eq(<<~CSV)
            Account address,Show boosts,Notify on new posts,Languages
            username@domain,true,false,en
          CSV
      end
    end
  end
end
