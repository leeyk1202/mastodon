# frozen_string_literal: true

class LeaveGroupService < BaseService
  include Payloadable
  include Redisable
  include Lockable

  # @param [Account] account Where to leave from
  # @param [Group] group Which group to unfollow
  def call(account, group)
    @account = account
    @group   = group

    leave! || undo_join_request!
  end

  private

  def leave!
    membership = GroupMembership.find_by(account: @account, group: @group)

    return unless membership

    membership.destroy!

    if @group.local?
      distribute_remove_to_remote_members!
    elsif @account.local?
      send_leave!(membership)
      send_undo!(membership)
    end

    membership
  end

  def undo_join_request!
    membership_request = GroupMembershipRequest.find_by(account: @account, group: @group)

    return unless membership_request

    membership_request.destroy!

    if @account.local? && !@group.local?
      send_leave!(membership_request)
      send_undo!(membership_request)
    end

    membership_request
  end

  def send_leave!(membership)
    payload = Oj.dump(serialize_payload(membership, ActivityPub::LeaveSerializer))
    ActivityPub::DeliveryWorker.perform_async(payload, membership.account_id, membership.group.inbox_url)
  end

  def send_undo!(membership_request)
    payload = Oj.dump(serialize_payload(membership_request, ActivityPub::UndoJoinSerializer))
    ActivityPub::DeliveryWorker.perform_async(payload, membership_request.account_id, membership_request.group.inbox_url)
  end

  def distribute_remove_to_remote_members!
    json = Oj.dump(serialize_payload(@account, ActivityPub::RemoveSerializer, target: ActivityPub::TagManager.instance.members_uri_for(@group), actor: ActivityPub::TagManager.instance.uri_for(@group)))
    ActivityPub::GroupRawDistributionWorker.perform_async(json, @group.id, [@account.inbox_url])
  end
end
