# frozen_string_literal: true

class BlockDomainFromAccountService < BaseService
  def call(account, domain)
    @account = account
    @domain  = domain

    @account.block_domain!(@domain)

    reject_existing_followers!
    reject_pending_follow_requests!
  end

  private

  def reject_existing_followers!
    @account.passive_relationships.where(account: Account.where(domain: @domain)).includes(:account).find_each do |follow|
      reject_follow!(follow)
    end
  end

  def reject_pending_follow_requests!
    FollowRequest.where(target_account: @account).where(account: Account.where(domain: @domain)).includes(:account).find_each do |follow_request|
      reject_follow!(follow_request)
    end
  end

  def reject_follow!(follow)
    json = Oj.dump(ActivityPub::LinkedDataSignature.new(ActiveModelSerializers::SerializableResource.new(
      follow,
      serializer: ActivityPub::RejectFollowSerializer,
      adapter: ActivityPub::Adapter
    ).as_json).sign!(@account))

    ActivityPub::DeliveryWorker.perform_async(json, @account.id, follow.account.inbox_url)
    follow.destroy
  end
end
