# frozen_string_literal: true

class ProcessHashtagsService < BaseService
  def call(status, tags = [])
    tags = status.text.scan(Tag::HASHTAG_RE).map(&:first) if status.local?

    tags.map { |str| str.mb_chars.downcase }.uniq.each do |tag|
      status.tags << Tag.where(name: tag).first_or_initialize(name: tag)
    end
  end
end
