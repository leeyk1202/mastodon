require 'rails_helper'

RSpec.describe TagManager do
  describe '#local_domain?' do
    # The following comparisons MUST be case-insensitive.

    around do |example|
      original_local_domain = Rails.configuration.x.local_domain
      Rails.configuration.x.local_domain = 'domain'

      example.run

      Rails.configuration.x.local_domain = original_local_domain
    end

    it 'returns true for nil' do
      expect(TagManager.instance.local_domain?(nil)).to eq true
    end

    it 'returns true if the slash-stripped string equals to local domain' do
      expect(TagManager.instance.local_domain?('DoMaIn/')).to eq true
    end

    it 'returns false for irrelevant string' do
      expect(TagManager.instance.local_domain?('DoMaIn!')).to eq false
    end
  end

  describe '#web_domain?' do
    # The following comparisons MUST be case-insensitive.

    around do |example|
      original_web_domain = Rails.configuration.x.web_domain
      Rails.configuration.x.web_domain = 'domain'

      example.run

      Rails.configuration.x.web_domain = original_web_domain
    end

    it 'returns true for nil' do
      expect(TagManager.instance.web_domain?(nil)).to eq true
    end

    it 'returns true if the slash-stripped string equals to web domain' do
      expect(TagManager.instance.web_domain?('DoMaIn/')).to eq true
    end

    it 'returns false for string with irrelevant characters' do
      expect(TagManager.instance.web_domain?('DoMaIn!')).to eq false
    end
  end

  describe '#normalize_domain' do
    it 'returns nil if the given parameter is nil' do
      expect(TagManager.instance.normalize_domain(nil)).to eq nil
    end

    it 'returns normalized domain' do
      expect(TagManager.instance.normalize_domain('DoMaIn/')).to eq 'domain'
    end
  end

  describe '#local_url?' do
    around do |example|
      original_web_domain = Rails.configuration.x.web_domain
      example.run
      Rails.configuration.x.web_domain = original_web_domain
    end

    it 'returns true if the normalized string with port is local URL' do
      Rails.configuration.x.web_domain = 'domain:42'
      expect(TagManager.instance.local_url?('https://DoMaIn:42/')).to eq true
    end

    it 'returns true if the normalized string without port is local URL' do
      Rails.configuration.x.web_domain = 'domain'
      expect(TagManager.instance.local_url?('https://DoMaIn/')).to eq true
    end

    it 'returns false for string with irrelevant characters' do
      Rails.configuration.x.web_domain = 'domain'
      expect(TagManager.instance.local_url?('https://domainn/')).to eq false
    end
  end

  describe '#same_acct?' do
    # The following comparisons MUST be case-insensitive.

    it 'returns true if the needle has a correct username and domain for remote user' do
      expect(TagManager.instance.same_acct?('username@domain', 'UsErNaMe@DoMaIn')).to eq true
    end

    it 'returns false if the needle is missing a domain for remote user' do
      expect(TagManager.instance.same_acct?('username@domain', 'UsErNaMe')).to eq false
    end

    it 'returns false if the needle has an incorrect domain for remote user' do
      expect(TagManager.instance.same_acct?('username@domain', 'UsErNaMe@incorrect')).to eq false
    end

    it 'returns false if the needle has an incorrect username for remote user' do
      expect(TagManager.instance.same_acct?('username@domain', 'incorrect@DoMaIn')).to eq false
    end

    it 'returns true if the needle has a correct username and domain for local user' do
      expect(TagManager.instance.same_acct?('username', 'UsErNaMe@Cb6E6126.nGrOk.Io')).to eq true
    end

    it 'returns true if the needle is missing a domain for local user' do
      expect(TagManager.instance.same_acct?('username', 'UsErNaMe')).to eq true
    end

    it 'returns false if the needle has an incorrect username for local user' do
      expect(TagManager.instance.same_acct?('username', 'UsErNaM@Cb6E6126.nGrOk.Io')).to eq false
    end

    it 'returns false if the needle has an incorrect domain for local user' do
      expect(TagManager.instance.same_acct?('username', 'incorrect@Cb6E6126.nGrOk.Io')).to eq false
    end
  end

  describe '#url_for' do
    let(:alice) { Fabricate(:account, username: 'alice') }

    subject { TagManager.instance.url_for(target) }

    context 'activity object' do
      let(:target) { Fabricate(:status, account: alice, reblog: Fabricate(:status)).stream_entry }

      it 'returns the unique tag for status' do
        expect(target.object_type).to eq :activity
        is_expected.to eq "https://cb6e6126.ngrok.io/@alice/#{target.id}"
      end
    end

    context 'comment object' do
      let(:target) { Fabricate(:status, account: alice, reply: true) }

      it 'returns the unique tag for status' do
        expect(target.object_type).to eq :comment
        is_expected.to eq "https://cb6e6126.ngrok.io/@alice/#{target.id}"
      end
    end

    context 'note object' do
      let(:target) { Fabricate(:status, account: alice, reply: false, thread: nil) }

      it 'returns the unique tag for status' do
        expect(target.object_type).to eq :note
        is_expected.to eq "https://cb6e6126.ngrok.io/@alice/#{target.id}"
      end
    end

    context 'person object' do
      let(:target) { alice }

      it 'returns the URL for account' do
        expect(target.object_type).to eq :person
        is_expected.to eq 'https://cb6e6126.ngrok.io/@alice'
      end
    end
  end

  describe 'path_to_resource!' do
    let!(:account) { Fabricate(:account, domain: nil, username: 'username') }

    it 'raise Mastodon::NotFound for plausible URL' do
      status = Fabricate(:status, account: account, id: 0)
      expect{ TagManager.instance.path_to_resource!('https://cb6e6126.ngrok.io/@username/0/embed') }.to raise_error Mastodon::NotFound
    end

    it 'raise Mastodon::NotFound if the given URL is not for the given class' do
      expect{ TagManager.instance.path_to_resource!('https://cb6e6126.ngrok.io/@username', Status) }.to raise_error Mastodon::NotFound
    end

    it 'returns Status for stream entry URL' do
      status = Fabricate(:status, account: account)
      stream_entry = Fabricate(:stream_entry, account: account, activity: status, id: 0)

      expect(TagManager.instance.path_to_resource!('https://cb6e6126.ngrok.io/users/username/updates/0')).to eq status
    end

    it 'returns Status for status URL' do
      status = Fabricate(:status, account: account, id: 0)
      expect(TagManager.instance.path_to_resource!('https://cb6e6126.ngrok.io/@username/0')).to eq status
    end

    it 'returns Account for account URL' do
      expect(TagManager.instance.path_to_resource!('https://cb6e6126.ngrok.io/@username')).to eq account
    end
  end

  describe 'path_to_resource' do
    it 'returns nil instead of raising Masotodon::NotFound' do
      account = Fabricate(:account, domain: nil, username: 'username')
      expect(TagManager.instance.path_to_resource('https://cb6e6126.ngrok.io/@username', Status)).to eq nil
    end

    it 'returns nil instead of raising ActiveRecord::NotFound' do
      expect(TagManager.instance.path_to_resource('https://cb6e6126.ngrok.io/@username')).to eq nil
    end
  end

  describe 'url_to_resource!' do
    let!(:account) { Fabricate(:account, domain: nil, username: 'username') }

    it 'returns resource if the given URL is local' do
      expect(TagManager.instance.url_to_resource!('https://cb6e6126.ngrok.io/@username')).to eq account
    end

    it 'returns Mastodon::NotFound if the given URL is remote' do
      expect{ TagManager.instance.url_to_resource!('https://example.com/@username') }.to raise_error Mastodon::NotFound
    end
  end

  describe 'url_to_resource' do
    let!(:account) { Fabricate(:account, domain: nil, username: 'username') }

    it 'returns resource if the given URL is local' do
      expect(TagManager.instance.url_to_resource('https://cb6e6126.ngrok.io/@username')).to eq account
    end

    it 'returns nil if the given URL is remote' do
      expect(TagManager.instance.url_to_resource('https://example.com/@username')).to eq nil
    end
  end
end
