# frozen_string_literal: true

class REST::CustomEmojiSerializer < ActiveModel::Serializer
  include RoutingHelper

  attributes :shortcode, :url, :static_url, :visible_in_picker

  def url
    full_asset_url(object.image.url)
  end

  def static_url
    full_asset_url(object.image.url(:static))
  end
end
