# frozen_string_literal: true

class Api::V1::Trends::TagsController < Api::V1::Trends::BaseController
  before_action :set_tags

  DEFAULT_RECORDS_LIMIT = 10

  def index
    cache_if_unauthenticated!
    render json: @tags, each_serializer: REST::TagSerializer, relationships: TagRelationshipsPresenter.new(@tags, current_user&.account_id)
  end

  private

  def set_tags
    @tags = if enabled?
              tags_from_trends.offset(offset_param).limit(limit_param(DEFAULT_RECORDS_LIMIT))
            else
              []
            end
  end

  def tags_from_trends
    Trends.tags.query.allowed
  end

  def next_path
    api_v1_trends_tags_url next_path_params if records_continue?
  end

  def prev_path
    api_v1_trends_tags_url prev_path_params if offset_param > limit_param(DEFAULT_RECORDS_LIMIT)
  end

  def records_continue?
    @tags.size == limit_param(DEFAULT_RECORDS_LIMIT)
  end
end
