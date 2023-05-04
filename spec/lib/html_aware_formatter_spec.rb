# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HtmlAwareFormatter do
  describe '#to_s' do
    let(:options) { {} }
    subject { described_class.new(text, local, options).to_s }

    context 'when local' do
      let(:local) { true }
      let(:text) { 'Foo bar' }

      it 'returns formatted text' do
        expect(subject).to eq '<p>Foo bar</p>'
      end
    end

    context 'when remote' do
      let(:local) { false }

      context 'given plain text' do
        let(:text) { 'Beep boop' }

        it 'keeps the plain text' do
          expect(subject).to include 'Beep boop'
        end
      end

      context 'given javascript links' do
        let(:text) { '<a href="javascript:alert(42)">javascript:alert(42)</a>' }

        it 'strips the javascript links' do
          is_expected.to_not include '<a'
        end
      end

      context 'given mentions' do
        let(:text) { '<a href="https://remote.com/@foo" class="mention">@<span>Foo</span></a> <a href="https://remote.com/@bar" class="mention">Barsname</a>' }
        let(:options) do
          {
            preloaded_accounts:
              [
                Fabricate(:account, domain: 'remote.com', username: 'foo', url: 'https://remote.com/@foo', uri: 'https://remote.com/users/foo'),
                Fabricate(:account, domain: 'remote.com', username: 'bar', url: 'https://remote.com/@bar', uri: 'https://remote.com/users/bar', display_name: 'Barsname'),
              ],
          }
        end

        it 'rewrites mentions' do
          is_expected.to include '>@<span>foo</span></a>'
          is_expected.to include '>@<span>bar</span></a>'
        end
      end

      context 'given text containing script tags' do
        let(:text) { '<script>alert("Hello")</script>' }

        it 'strips the scripts' do
          expect(subject).to_not include '<script>alert("Hello")</script>'
        end
      end

      context 'given text containing malicious classes' do
        let(:text) { '<span class="mention  status__content__spoiler-link">Show more</span>' }

        it 'strips the malicious classes' do
          expect(subject).to_not include 'status__content__spoiler-link'
        end
      end
    end
  end
end
