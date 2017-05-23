require 'rails_helper'
require 'pundit/rspec'

RSpec.describe StatusPolicy, type: :model do
  subject { described_class }

  let(:alice) { Fabricate(:account, username: 'alice') }
  let(:status) { Fabricate(:status, account: alice) }

  permissions :show? do
    it 'grants access when direct and account is viewer' do
      status.visibility = :direct
      expect(subject).to permit(status.account, status)
    end

    it 'grants access when direct and viewer is mentioned' do
      status.visibility = :direct
      status.mentions = [Fabricate(:mention, account: alice)]

      expect(subject).to permit(alice, status)
    end

    it 'denies access when direct and viewer is not mentioned' do
      viewer = Fabricate(:account)
      status.visibility = :direct

      expect(subject).to_not permit(viewer, status)
    end

    it 'grants access when private and account is viewer' do
      status.visibility = :direct

      expect(subject).to permit(status.account, status)
    end

    it 'grants access when private and account is following viewer' do
      follow = Fabricate(:follow)
      status.visibility = :private
      status.account = follow.target_account

      expect(subject).to permit(follow.account, status)
    end

    it 'grants access when private and viewer is mentioned' do
      status.visibility = :private
      status.mentions = [Fabricate(:mention, account: alice)]

      expect(subject).to permit(alice, status)
    end

    it 'denies access when private and viewer is not mentioned or followed' do
      viewer = Fabricate(:account)
      status.visibility = :private

      expect(subject).to_not permit(viewer, status)
    end

    it 'grants access when no viewer' do
      expect(subject).to permit(nil, status)
    end

    it 'denies access when viewer is blocked' do
      block = Fabricate(:block)
      status.visibility = :private
      status.account = block.target_account

      expect(subject).to_not permit(block.account, status)
    end
  end
end
