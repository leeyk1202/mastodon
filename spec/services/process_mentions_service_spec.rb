require 'rails_helper'

RSpec.describe ProcessMentionsService, type: :service do
  let(:account)    { Fabricate(:account, username: 'alice') }
  let(:visibility) { :public }
  let(:status)     { Fabricate(:status, account: account, text: "Hello @#{remote_user.acct}", visibility: visibility) }

  subject { ProcessMentionsService.new }

  context 'ActivityPub' do
    context do
      let!(:remote_user) { Fabricate(:account, username: 'remote_user', protocol: :activitypub, domain: 'example.com', inbox_url: 'http://example.com/inbox') }

      before do
        subject.call(status)
      end

      it 'creates a mention' do
        expect(remote_user.mentions.where(status: status).count).to eq 1
      end
    end

    context 'with an IDN domain' do
      let!(:remote_user) { Fabricate(:account, username: 'sneak', protocol: :activitypub, domain: 'xn--hresiar-mxa.ch', inbox_url: 'http://example.com/inbox') }
      let!(:status) { Fabricate(:status, account: account, text: "Hello @sneak@hæresiar.ch") }

      before do
        subject.call(status)
      end

      it 'creates a mention' do
        expect(remote_user.mentions.where(status: status).count).to eq 1
      end
    end

    context 'with an IDN TLD' do
      let!(:remote_user) { Fabricate(:account, username: 'foo', protocol: :activitypub, domain: 'xn--y9a3aq.xn--y9a3aq', inbox_url: 'http://example.com/inbox') }
      let!(:status) { Fabricate(:status, account: account, text: "Hello @foo@հայ.հայ") }

      before do
        subject.call(status)
      end

      it 'creates a mention' do
        expect(remote_user.mentions.where(status: status).count).to eq 1
      end
    end
  end

  context 'Temporarily-unreachable ActivityPub user' do
    let!(:remote_user) { Fabricate(:account, username: 'remote_user', protocol: :activitypub, domain: 'example.com', inbox_url: 'http://example.com/inbox', last_webfingered_at: nil) }

    before do
      stub_request(:get, "https://example.com/.well-known/host-meta").to_return(status: 404)
      stub_request(:get, "https://example.com/.well-known/webfinger?resource=acct:remote_user@example.com").to_return(status: 500)
      subject.call(status)
    end

    it 'creates a mention' do
      expect(remote_user.mentions.where(status: status).count).to eq 1
    end
  end

  context 'local mentions in groups' do
    let!(:bob) { Fabricate(:account, username: 'bob') }
    let!(:eve) { Fabricate(:account, username: 'eve') }
    let!(:group) { Fabricate(:group) }
    let!(:account_membership) { Fabricate(:group_membership, group: group, account: account) }
    let!(:eve_membership)     { Fabricate(:group_membership, group: group, account: eve) }
    let!(:status) { Fabricate(:status, account: account, text: 'Hello @bob @eve', visibility: 'group', group: group) }

    before do
      subject.call(status)
    end

    it 'creates a mention to eve' do
      expect(eve.mentions.where(status: status).count).to eq 1
    end

    it 'does not create a mention to bob' do
      expect(bob.mentions.where(status: status).count).to eq 0
    end
  end
end
