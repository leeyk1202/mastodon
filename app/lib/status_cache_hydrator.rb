# frozen_string_literal: true

class StatusCacheHydrator
  def initialize(status)
    @status = status
  end

  def hydrate(account_id)
    # The cache of the serialized hash is generated by the fan-out-on-write service
    payload = Rails.cache.fetch("fan-out/#{@status.id}") { InlineRenderer.render(@status, nil, :status) }

    # If we're delivering to the author who disabled the display of the application used to create the
    # status, we need to hydrate the application, since it was not rendered for the basic payload
    payload[:application] = ActiveModelSerializers::SerializableResource.new(@status.application, serializer: REST::StatusSerializer::ApplicationSerializer).as_json if payload[:application].nil? && @status.account_id == account_id

    # We take advantage of the fact that some relationships can only occur with an original status, not
    # the reblog that wraps it, so we can assume that some values are always false
    if payload[:reblog]
      payload[:muted]      = false
      payload[:bookmarked] = false
      payload[:pinned]     = false if @status.account_id == account_id
      payload[:filtered]   = CustomFilter.apply_cached_filters(CustomFilter.cached_filters_for(@status.reblog_of_id), @status.reblog).map { |filter| ActiveModelSerializers::SerializableResource.new(filter, serializer: REST::FilterResultSerializer).as_json }

      # If the reblogged status is being delivered to the author who disabled the display of the application
      # used to create the status, we need to hydrate it here too
      payload[:reblog][:application] = ActiveModelSerializers::SerializableResource.new(@status.reblog.application, serializer: REST::StatusSerializer::ApplicationSerializer).as_json if payload[:reblog][:application].nil? && @status.reblog.account_id == account_id && @status.reblog.application_id.present?

      payload[:reblog][:favourited] = Favourite.where(account_id: account_id, status_id: @status.reblog_of_id).exists?
      payload[:reblog][:reblogged]  = Status.where(account_id: account_id, reblog_of_id: @status.reblog_of_id).exists?
      payload[:reblog][:muted]      = ConversationMute.where(account_id: account_id, conversation_id: @status.reblog.conversation_id).exists?
      payload[:reblog][:bookmarked] = Bookmark.where(account_id: account_id, status_id: @status.reblog_of_id).exists?
      payload[:reblog][:pinned]     = StatusPin.where(account_id: account_id, status_id: @status.reblog_of_id).exists? if @status.reblog.account_id == account_id
      payload[:reblog][:filtered]   = payload[:filtered]

      if payload[:reblog][:poll]
        if @status.reblog.account_id == account_id
          payload[:reblog][:poll][:voted] = true
          payload[:reblog][:poll][:own_votes] = []
        else
          own_votes = PollVote.where(poll_id: @status.reblog.poll_id, account_id: account_id).pluck(:choice)
          payload[:reblog][:poll][:voted] = !own_votes.empty?
          payload[:reblog][:poll][:own_votes] = own_votes
        end
      end

      payload[:favourited] = payload[:reblog][:favourited]
      payload[:reblogged]  = payload[:reblog][:reblogged]
    else
      payload[:favourited] = Favourite.where(account_id: account_id, status_id: @status.id).exists?
      payload[:reblogged]  = Status.where(account_id: account_id, reblog_of_id: @status.id).exists?
      payload[:muted]      = ConversationMute.where(account_id: account_id, conversation_id: @status.conversation_id).exists?
      payload[:bookmarked] = Bookmark.where(account_id: account_id, status_id: @status.id).exists?
      payload[:pinned]     = StatusPin.where(account_id: account_id, status_id: @status.id).exists?
      payload[:filtered]   = CustomFilter.apply_cached_filters(CustomFilter.cached_filters_for(@status.id), @status).map { |filter| ActiveModelSerializers::SerializableResource.new(filter, serializer: REST::FilterResultSerializer).as_json }
    end

    payload
  end
end
