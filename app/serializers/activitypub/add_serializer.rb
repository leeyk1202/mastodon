# frozen_string_literal: true

class ActivityPub::AddSerializer < ActiveModel::Serializer
  include RoutingHelper

  attributes :id, :type, :actor, :target
  attribute :proper_object, key: :object

  def id
    nil
  end

  def type
    'Add'
  end

  def actor
    ActivityPub::TagManager.instance.uri_for(object.account)
  end

  def proper_object
    ActivityPub::TagManager.instance.uri_for(object)
  end

  def target
    account_collection_url(object, :featured)
  end
end
